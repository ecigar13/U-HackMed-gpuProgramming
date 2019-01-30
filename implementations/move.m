function[molArrayNew,molArrayOld,clusterMolsMap] = move(molArrayNew, molArrayOld,clusterMolsMapOld,...
   clusterMolsMapNew,stepStd,dissociationProb)
%MOVE move independent molecules and clusters

  [molArrayNew,molArrayOld]=moveIndependentMol(molArrayNew,molArrayOld,stepStd,dissociationProb)
  [clusterMolsMapNew,clusterMolsMapOld]=moveClusters(clusterMolsMapOld,clusterMolsMapNew,stepStd,dissociationProb)

end

function[clusterMolsMapNew,clusterMolsMapOld]=moveClusters(clusterMolsMapOld,clusterMolsMapNew,stepStd,...
  dissociationProb)

  %if there's no cluster. 
  if(size(keys(clusterMolsMapNew)(2))==0)
    return
  end

  clusterMolsMapOld=clusterMolsMapNew;
  clusterIds=keys(clusterMolsMapNew);
  parfor i = 1: length(clusterIds)
    %generate random x,y,z movement.
    %column 1,2,3,4 is clusterid,x, y, z. Clusterid should be 0 for independent molecules.
    rows=size(clusterMolsMapNew(i))(1);
    receptorDisp = stepStd*randn(1,3);  %3 is for x, y, z
    receptorDisp=repmat(receptorDisp,rows,1)  %repeat it for all molecules. Then apply it to the value.
    clusterMolsMapNew(i)(:,[2:4]) = clusterMolsMapNew(i)(:,[2:4])+receptorDisp;

    %make sure that receptors stay inside the region of interest (not below 0 and not above limit)
    correctionBoundaryLow = max(clusterMolsMapNew(i)(:,[2:4]),0);
    clusterMolsMapNew(i)(:,[2:4])=clusterMolsMapNew(i)(:,[2:4]) - 2 * correctionBoundaryLow;
    correctionBoundaryHigh = min(clusterMolsMapNew(i)(:,[2:4]),repmat(observeSideLen(1),rows,3));
  end
end

function[molArrayNew,molArrayOld]=moveIndependentMol(molArrayNew, molArrayOld,stepStd,dissociationProb)
  
  %move the independentMols first
  %Save the old position, then assign the new position.
  row = size(molArrayNew)(1)
  col=size(molArrayNew)(2)

  %column 1,2,3,4 is clusterid,x, y, z. Clusterid should be 0 for independent molecules.
  molArrayOld(:,[1:col]) = molArrayNew(:,[1:col]);
  receptorDisp = stepStd*randn(row,3);
  molArrayNew(:,[2:4]) = molArrayNew(:,[2:4])+receptorDisp;

  %make sure that receptors stay inside the region of interest (not below 0 and not above limit)
  correctionBoundaryLow = max(molArrayNew(:,[2:4]),0);
  molArrayNew(:,[2:4])=molArrayNew(:,[2:4]) - 2 * correctionBoundaryLow;
  correctionBoundaryHigh = min(molArrayNew(:,[2:4]),repmat(observeSideLen(1),row,3));

end
