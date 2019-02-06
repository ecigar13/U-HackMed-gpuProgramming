function [receptorInfoAll,receptorInfoLabeled,timeIterArray,errFlag,assocStats,collProbStats,totalPossibleAssociation] ...
    = receptorAggregationSimple_new(modelParam,simParam)
  %RECEPTORAGGREGATIONSIMPLE simulates the aggregation of simply diffusing receptors
  %
  %SYNOPSIS [receptorInfoAll,receptorInfoLabeled,timeIterArray,errFlag] ...
  %    = receptorAggregationSimple(modelParam,simParam)
  %
  %INPUT  modelParam: Structure with the fields:
  %           diffCoef        : Diffusion coefficient (microns^2/s)
  %           receptorDensity : Receptor density (#/microns^probDim).
  %           aggregationProb : Probability of aggregation if a receptor
  %                             bumps into another receptor or receptor
  %                             complex.
  %           aggregationDist : Distance between 2 receptors to consider them
  %                             bumping into each other, thus potentially
  %                             aggregating (microns).
  %           dissociationRate: Rate of dissociation of a receptor from a
  %                             receptor complex (#/s).
  %           labelRatio      : Receptor labeling ratio.
  %           intensityQuantum: Row vector with 2 values, the mean and std of
  %                             receptor labeling intensities.
  %           initPositions   : Receptor initial positions. If supplied, they
  %                             will be used. If not, random positions will
  %                             be chosen.
  %       simParam: Structure with the fields:
  %           probDim         : System dimensionality (1, 2 or 3). Default: 2.
  %           observeSideLen  : Observation side length (microns). Either one
  %                             value, used for all probDims, or a row
  %                             vector with a value for each probDim.
  %                             Default: 1 in all probDims.
  %           timeStep        : Simulation time step (s).
  %                             Default: 0.01/max(diffCoef,dissociationRate).
  %           simTime         : Total time of simulation (s).
  %                             Default: 100 * timeStep.
  %           initTime        : Initialization time, to remove any
  %                             initialization artifacts.
  %                             Default: 100 * timeStep.
  %           randNumGenSeeds : Row vector storing the seeds for the "rand"
  %                             and "randn" random number generators.
  %                             Default: [100 100].
  %                 Whole structure optional. Individual fields also optional.
  %
  %OUTPUT receptorInfoAll     : Structure with fields:
  %           .receptorTraj        : (Number of receptors) - by - (probDim)
  %                                  - by - (number of iterations) array storing
  %                                  receptor positions.
  %           .recept2clustAssign  : (Number of receptors) - by - (number of
  %                                  iterations) array storing the cluster
  %                                  assignment of each receptor.
  %           .clust2receptAssign  : (Maximum number of clusters) - by - (maximum
  %                                  cluster size) - by - (number of iterations)
  %                                  array storing the receptor membership to each
  %                                  cluster.
  %            .modelParam: the imput model parameters 
  %            .simParam: the imput simulation parameters
  %       receptorInfoLabeled : The same as receptorInfoAll, but for labaled
  %                             receptors only. It also has the additional
  %                             field:
  %           .compTracks          : The receptor trajectories and
  %                                  interactions over time, as converted by
  %                                  convReceptClust2CompTracks. Same format
  %                                  as output of trackCloseGapsKalman.
  %       timeIterArray       : Vector storing time corresponding to each
  %                             iteration.
  %       errFlag : 0 if function executes normally, 1 otherwise.
  %
  %       assocStats: a struct containing details on sure, potential and
  %                   probability based associations, at each iteraion.
  %                   The fields are:
  %                   numSureAssoc - number of sure associations
  %                   numPotColl - number of potentail collisions
  %                   numColl - number of collision from potential collisions
  %                   numPotColl_Assoc - number of actual association that
  %                                      resulted from potentail collisions
  %                   sureAssocCountBySize - sure associations by cluster
  %                                          size
  %                   numCollProbPairs - number of pairs in collision via
  %                                      probablity
  %
  %       collProbStats:  statistics specifically for collisions based on
  %                       probablity at each iteration. This is a struct with
  %                       fields:
  %                       collisionProb - the probablity value
  %                       pwDist - pairwise distance
  %                       primaryNodeRadius - radius for primary node
  %                       partnerNodeRadii - set of radii for partner nodes
  %
  %        LRO included a new output for the count of the possible associations
  %       totalPossibleAssociation: total number of possible associations
  %       between receptors and cluster and receptors.
  %      
  %Khuloud Jaqaman, January 2009
  %
  %Modified June 2013 - December 2014, Robel Yirdaw
  %
  % Modified 2017/11/30 Luciana de Oliveira

  %% Output
  errFlag = 0;
  receptorInfoAll = [];
  timeIterArray = [];

  % Initiate the counts for the possible associations
  totalPossibleAssociation=0;
  totalPossAssFirst=0;
  totalPossAssSecond=0;

  %% Verify input and assign default value. 
  [errFlag,diffCoef,receptorDensity,aggregationProb, aggregationDist, dissociationRate,labelRatio,initPositions,... 
  intensityQuantum,probDim,observeSideLen,timeStep,simTime,initTime,randNumGenSeeds] = verifyInput(modelParam,simParam,...
   errFlag);

  %exit if there are missing model parameters
  if errFlag == 1
    disp('--receptorAggregationSimple: Please supply missing variables!');
    return
  end

  %determine number of iterations to perform
  totalTime = simTime + initTime;
  numIterSim = ceil( simTime / timeStep ) + 1;
  numIterInit = ceil( initTime / timeStep );
  numIterations = numIterSim + numIterInit;

  %store time correponding to each iteration
  timeIterArray = (0 : numIterSim - 1)' * timeStep;

  %assuming that the displacement taken in a timeStep is normally distributed
  %with mean zero, get standard deviation of step distribution from diffusion
  %coefficient
  stepStd = sqrt( 2 * diffCoef * timeStep );

  %adjust aggregationDist to account for the finite simulation time step and
  %the expected receptor displacement in that time step
  aggregationDistCorr = max(aggregationDist,sqrt(probDim)*stepStd*2);

  associationDistVals = struct('associationDist',aggregationDist,...
      'associationDistCorr',aggregationDistCorr);

  %calculate dissociation probability
  dissociationProb = dissociationRate * timeStep;

  %initialize random number generators
  rng(randNumGenSeeds(1),'twister')

  %% receptor initial positions and clustering
  obsRegionSize = prod(observeSideLen); %calculate observation region size
  disp(obsRegionSize)
  if isempty(initPositions)
      numReceptors = round(obsRegionSize * receptorDensity);  %calculate number of receptors
      initPositions = rand(numReceptors,probDim) .* repmat(observeSideLen,numReceptors,1); %initialize receptor positions
  else
      %get number of receptors
      numReceptors = size(initPositions,1);
  end

  progressText(0,'Simulation');

  %{
    ##initiate a bunch of particles
    ##set the bounds
    ##move them ---> will use a lot
    ##associate them ---> if they do so.
    ##dissociationProb = dissociationRate * timeStep;
  %}
  
  molArrayOld = ones(numReceptors,4);
  molArrayNew = ones(numReceptors,4);
  %set cluster id to 0
  molArrayNew(:,1) = 0;
  molArrayOld(:,1)=0;

  %initialize the cluster-molecules map. Set UniformValues to false.  
  clusterMolsMapNew = containers.Map(0,0,'UniformValues',false);
  clusterMolsMapOld = containers.Map(0,0,'UniformValues',false);


  %iterate in time
  for iIter = 2 : numIterations
      fprintf('\niIter = %d\n',iIter);
      %%%%%%%%%%%%%%%%%%%%%%% Moving the receptors
      [molArrayNew,molArrayOld,clusterMolsMapOld, clusterMolsMapNew] = move(molArrayNew, molArrayOld,clusterMolsMapOld,...
          clusterMolsMapNew,stepStd,dissociationProb,observeSideLen);
      
      %% Dissociation
      %allow receptors in clusters to dissociate in current time point
      [molArrayNew,molArrayOld,clusterMolsMapOld, clusterMolsMapNew] = receptorDissociationAlg(...
        molArrayNew,molArrayOld,clusterMolsMapOld, clusterMolsMapNew, dissociationProb);
      
          %%Working on disassociation.
      aggregationProbVec = ones(numReceptors,1);
      
      %% Association - not done.
      try     
          numClustPre = length(cluster2receptor(:,1));
          
          [cluster2receptor,receptor2cluster,clusterSize,positionsNew,aggregationProbVec,sureAssocCount,numberPossibleAssociations] = ...
              receptorAggregationAlg_maxWeightedMatching_sureColl(positionsNew,...
              aggregationDist,aggregationProbVec,aggregationProb,receptor2cluster,...
              cluster2receptor,clusterSize);        
          
          % Modification LRO 2017/11/30 to calculate the number of
          % possible associations now I add a new output for the function
          totalPossAssFirst=totalPossAssFirst+numberPossibleAssociations;
          numClustPost = length(cluster2receptor(:,1));
          assocStats.numSureAssoc(iIter,1) = numClustPre - numClustPost;
          
          %assocStats.numSureAssoc(iIter,2) = nansum(sureAssocCount);
          assocStats.sureAssocCountBySize(1:length(sureAssocCount),iIter) = sureAssocCount;
          clear numClustPre numClustPost sureAssocCount
      
      catch newAssocFunExcep        
          fprintf('\nError at iIter = %d\n',iIter);
          disp(newAssocFunExcep.message);
          pause;
          return;
      end

      [~,receptor2cluster,cluster2receptor,clusterSize,...
          positionsNew,numPotColl,numColl,numPotColl_Assoc,numCollProbPairs,...
          collProbStatsTemp,possibleAssociations] =...
          receptorAggregationAlg_maxWeightedMatching_potColl(...
          cluster2receptor,receptor2cluster,positionsOld,positionsNew,...
          aggregationProbVec,aggregationProb,associationDistVals,clusterSize);

      % Modification LRO 2017/11/30 to calculate the number of
      % possible associations now I add a new output for the function
      totalPossAssSecond=totalPossAssSecond+possibleAssociations;
      %calculate the total number of possible associations
      totalPossibleAssociation=totalPossAssFirst+totalPossAssSecond;
      
      assocStats.numPotColl(iIter) = numPotColl;
      assocStats.numColl(iIter) = numColl;
      assocStats.numPotColl_Assoc(iIter) = numPotColl_Assoc;
      assocStats.numCollProbPairs(iIter) = numCollProbPairs;

      collProbStats(iIter) = collProbStatsTemp;
      [numClusters,maxClustSize] = size(cluster2receptor);
      
      %store new receptor information
      receptorTraj(:,:,iIter) = positionsNew;
      recept2clustAssign(:,iIter) = receptor2cluster;
      clust2receptAssign(1:numClusters,1:maxClustSize,iIter) = cluster2receptor;

      progressText((iIter-1)/(numIterations-1),'Simulation');
    
  end %(for iIter = 2 : numIterations)

  %% Post-processing
  %remove the initialization period from simulation
  receptorTraj = receptorTraj(:,:,numIterInit+1:end);
  recept2clustAssign = recept2clustAssign(:,numIterInit+1:end);
  clust2receptAssign = clust2receptAssign(:,:,numIterInit+1:end);

  %remove empty rows and columns from clust2receptAssign
  cluster2receptor = max(clust2receptAssign,[],3);
  columnSum = sum(cluster2receptor);
  clust2receptAssign = clust2receptAssign(:,columnSum~=0,:);
  rowSum = sum(cluster2receptor,2);
  clust2receptAssign = clust2receptAssign(rowSum~=0,:,:);

  %put information in receptorInfoAll
  receptorInfoAll = struct('receptorTraj',receptorTraj,'recept2clustAssign',...
      recept2clustAssign,'clust2receptAssign',clust2receptAssign,'simParam',simParam,'modelParam',modelParam);

  %% Receptor labeling and sub-sampling
  %KJ (150528): call function to label and sub-sample
  receptorInfoLabeled = genReceptorInfoLabeled(receptorInfoAll,...
      labelRatio,intensityQuantum);
end

%% ~~~ the end ~~~


