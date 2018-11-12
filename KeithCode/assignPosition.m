

function [initPositions] = assignPosition(observeSideLen, probDim)
%GENERATECELLARRAY generate 1d array of X, Y pair
%  probDim         : System dimensionality (1, 2 or 3). Default: 2.
    
    %calculate observation region size
    obsRegionSize = prod(observeSideLen);   

    %calculate number of receptors
    numReceptors = round(obsRegionSize * receptorDensity);
    
    firstArr=gpuArray( rand(numReceptors,probDim) );
    secondArr=gpuArray(repmat(observeSideLen,numReceptors,1));
    
    %initialize receptor positions
    initPositions = firstArr .* secondArr;
    initPositions=gather(initPositions);
end
