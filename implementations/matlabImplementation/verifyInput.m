function[errFlag,diffCoef,receptorDensity,aggregationProb, aggregationDist, dissociationRate,labelRatio,initPositions,...
  intensityQuantum,probDim,observeSideLen,timeStep,simTime,initTime,randNumGenSeeds] = verifyInput(modelParam,simParam, errFlag)

  %check if correct number of arguments were used when function was called
  if nargin < 1
      disp('--receptorAggregationSimple: Too few input arguments');
      errFlag  = 1;
  end

  %extract model parameters from modelParam

  %diffusion coefficient
  if isfield(modelParam,'diffCoef')
      diffCoef = modelParam.diffCoef;
  else
      disp('--receptorAggregationSimple: Please supply diffusion coefficient');
      errFlag = 1;
  end

  %receptor density
  if isfield(modelParam,'receptorDensity')
      receptorDensity = modelParam.receptorDensity;
  else
      disp('--receptorAggregationSimple: Please supply receptor density');
      errFlag = 1;
  end

  %aggregation probability
  if isfield(modelParam,'aggregationProb')
      aggregationProb = modelParam.aggregationProb;
  else
      disp('--receptorAggregationSimple: Please supply aggregation probability');
      errFlag = 1;
  end

  %aggregation distance
  if isfield(modelParam,'aggregationDist')
      aggregationDist = modelParam.aggregationDist;
  else
      disp('--receptorAggregationSimple: Please supply aggregation distance');
      errFlag = 1;
  end

  %dissociation rate
  if isfield(modelParam,'dissociationRate')
      dissociationRate = modelParam.dissociationRate;
  else
      disp('--receptorAggregationSimple: Please supply dissociation rate');
      errFlag = 1;
  end

  %labeling ratio
  if isfield(modelParam,'labelRatio')
      labelRatio = modelParam.labelRatio;
  else
      disp('--receptorAggregationSimple: Please supply labeling ratio');
      errFlag = 1;
  end

  %receptor initial positions
  if isfield(modelParam,'initPositions')
      initPositions = modelParam.initPositions;
  else
      initPositions = [];
  end

  %intensity quantum
  if isfield(modelParam,'intensityQuantum')
      intensityQuantum = modelParam.intensityQuantum;
  else
      disp('--receptorAggregationSimple: Please supply intensity quantum');
      errFlag = 1;
  end

  %check model parameters ...

  %some must be positive
  %09/05/14 - modified to accomodate a vector labelRatio
  if any([receptorDensity aggregationDist (labelRatio(:)') intensityQuantum(1)] <= 0)
      disp('--receptorAggregationSimple: Receptor density, aggregation distance, labeling ratio and intensity quantum should be positive');
      errFlag = 1;
  end


  %and some must be non-negative
  %03/25/14 - modified to accomodate a vector aggregationProb
  if any([diffCoef (aggregationProb') dissociationRate intensityQuantum(2)] < 0)
      disp('--receptorAggregationSimple: Diffusion coefficient, aggregation probability and dissociation rate should be non-negative');
      errFlag = 1;
  end

  %extract simulation parameters from simParam

  %if simParam wasn't supplied at all
  if nargin < 2 || isempty(simParam)

      probDim = 2;
      observeSideLen = ones(1,probDim);
      timeStep = 0.01 / max(diffCoef,dissociationRate); 
      simTime = 100 * timeStep;
      initTime = 100 * timeStep;
      randNumGenSeeds = [100 100];

  else

      %system probDimality
      if isfield(simParam,'probDim')
          probDim = simParam.probDim;
      else
          probDim = 2;
      end

      %observation side length
      if isfield(simParam,'observeSideLen')
          observeSideLen = simParam.observeSideLen;
          if length(observeSideLen) == 1
              observeSideLen = observeSideLen * ones(1,probDim);
          end
      else
          observeSideLen = ones(1,probDim);
      end

      %time step
      if isfield(simParam,'timeStep')
          timeStep = simParam.timeStep;
      else
          timeStep = 0.01 / max(diffCoef,dissociationRate);
      end

      %simulation time
      if isfield(simParam,'simTime')
          simTime = simParam.simTime;
      else
          simTime = 100 * timeStep;
      end

      %initialization time
      if isfield(simParam,'initTime')
          initTime = simParam.initTime;
      else
          initTime = 100 * timeStep;
      end

      %random number generator seeds
      if isfield(simParam,'randNumGenSeeds')
          randNumGenSeeds = simParam.randNumGenSeeds;
      else
          randNumGenSeeds = [100 100];
      end

  end
