function runReceptorAggregationSimple_HPC_PAR_20170519(runIndex,receptorDensity,...
    aggregationProb,dissRate)
%  Probe runs with receptor density of 20. Will save label
%  ratios 0.01 to 0.06.
%
%  28 April 2015
%  19 May 2017 updated for paraRunner
%


rDdir=['rD', num2str(receptorDensity)];
dRdir=[rDdir, '/dR', num2str(dissRate)];
aPdir=[dRdir, '/aP', num2str(aggregationProb)];

if ~exist(rDdir,'dir')
    mkdir(rDdir)
end

if ~exist(dRdir,'dir')
    mkdir(dRdir)
end

if ~exist(aPdir,'dir')
    mkdir(aPdir)
end

fprintf('\n======================================');
fprintf('\nProbe IS run # %d.',runIndex);
fprintf('\n======================================\n');

load('allRN_30.mat');

modelParam =struct('diffCoef',0.1,'receptorDensity',receptorDensity,'aggregationProb',...
    aggregationProb*[0;ones(4,1);0],...
    'aggregationDist',0.01,'dissociationRate',dissRate,'labelRatio',1,...
    'intensityQuantum',[1 0.3]);
simParam = struct('probDim',2,'observeSideLen',25,'timeStep',0.01,'simTime',10,...
    'initTime',10,'randNumGenSeeds',allRN_30(runIndex));

fprintf('\n=========================================================================');
fprintf('\ndiffCoeff = %g                           |   probDim = %g',modelParam.diffCoef,simParam.probDim);
fprintf('\nreceptorDensity = %g                       |   observeSideLen = %g',modelParam.receptorDensity,simParam.observeSideLen);
fprintf('\naggregationProb = [%g;%g;%g;%g;%g;%g]   |   timeStep = %g',modelParam.aggregationProb,simParam.timeStep);
fprintf('\naggregationDist = %g                    |   simTime = %g',modelParam.aggregationDist,simParam.simTime);
fprintf('\ndissociationRate = %g                      |   initTime = %g         ',modelParam.dissociationRate,simParam.initTime);
fprintf('\nlabelRatio = [%g;%g;%g;%g;%g;%g;%g]  |   randNumGenSeed = %d   ',modelParam.labelRatio,simParam.randNumGenSeeds);
fprintf('\nintensityQuantum = [%g %g]                |    ',modelParam.intensityQuantum);
fprintf('\n=========================================================================\n');

tic

[receptorInfoAll,receptorInfoLabeled,~,~,assocStats,collProbStats] =...
    receptorAggregationSimple_new(modelParam,simParam);

elapsedTime = toc;

fprintf('\n=====================================================');
fprintf('\nTotal runtime %f.',elapsedTime);
fprintf('\n=====================================================\n');

try
    outDir = [aPdir,'/out',int2str(runIndex)];
    outFile = [outDir,'/out',int2str(runIndex),'.mat'];
    mkdir(outDir);
    
    %Save receptorInfoAll and receptorInfoLabeled separately
    save([outDir,'/receptorInfoAll',int2str(runIndex),'.mat'],'receptorInfoAll','-v7.3');
    clear receptorInfoAll
    
    save([outDir,'/receptorInfoLabeled',int2str(runIndex),'.mat'],'receptorInfoLabeled','-v7.3');
    clear receptorInfoLabeled
    
    save(outFile,'-v7.3');
    fprintf('\n=====================================================');
    fprintf('\nVariables written to %s.',outFile);
    fprintf('\n=====================================================\n');
catch outErr
    disp(outErr.message);
end

end

