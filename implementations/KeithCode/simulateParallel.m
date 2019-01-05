function [individualParticleArray,polymerParticlesArray] = simulateParallel(...
    observeSideLen, probDim,runIndex,receptorDensity,aggregationProb,dissRate,...
    numberOfTurns)
%Here's the flow: dissociation -> move the particles -> associate the
%clusters
%   Create the initial position array
individualParticleArray = assignPosition(observeSideLen, probDim);

for i=1:numberOfTurns
    individualParticleArray,polymerParticlesArray=dissociateParallel(...
        individualParticleArray,polymerParticlesArray);
    individualParticleArray,polymerParticlesArray=moveParticles(...
        individualParticleArray,polymerParticlesArray);
    individualParticleArray,polymerParticlesArray=associateParticles(...
        individualParticleArray,polymerParticlesArray);
    
end

end

function[individualParticleArray,polymerParticlesArray]=dissociateParallel(...
    individualParticleArray,polymerParticlesArray, dissociateProbability)
%Dissociate the particle pairs and come up with solution. Anything left
%unassociated are moved to invididualParticleArray


end

function[individualParticleArray,polymerParticlesArray] = moveParticles(...
    individualParticleArray,polymerParticlesArray )
%Move the particles and the pairs.

end

function[individualParticleArray,polymerParticlesArray]=associateParticles(...
    individualParticleArray,polymerParticlesArray, associateProbability)
%decide if particles should associate to make polymers.
%return a cell array of x and y of all particles.

end