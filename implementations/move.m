function[molArrayNew,molArrayOld,clusterMolsMap] = move(molArrayNew, molArrayOld,clusterMolsMapOld,...
   clusterMolsMapNew,stepStd,dissociationProb, observeSideLen)
%MOVE move independent molecules and clusters

  [molArrayNew,molArrayOld]=moveIndependentMol(molArrayNew,molArrayOld,stepStd,dissociationProb,observeSideLen);
  [clusterMolsMapNew,clusterMolsMapOld]=moveClusters(clusterMolsMapOld,clusterMolsMapNew,stepStd,dissociationProb,observeSideLen);

end

function[clusterMolsMapNew,clusterMolsMapOld]=moveClusters(clusterMolsMapOld,clusterMolsMapNew,stepStd,...
  dissociationProb,observeSideLen)

  %if there's no cluster:
  clusterIds=keys(clusterMolsMapNew);

  %matlab doesn't allow chaining command.
  if(length(clusterIds)==0)
    return
  end
  
  clusterMolsMapOld=clusterMolsMapNew;
  
  disp(clusterIds)
  parfor i = 1: length(clusterIds)
    %generate random x,y,z movement.
    %column 1,2,3,4 is clusterid,x, y, z. Clusterid should be 0 for independent molecules.
    temp=size(clusterMolsMapNew(i));
    rows=temp(1);
    
    temp1 = clusterMolsMapNew(i);
    receptorDisp = stepStd*randn(1,3);  %3 is for x, y, z
    receptorDisp=repmat(receptorDisp,rows,1)  %repeat it for all molecules. Then apply it to the value.
    temp1 = temp1(:,[2:4])+receptorDisp;
    
    %make sure that receptors stay inside the region of interest (not below 0 and not above limit)
    temp1 = clusterMolsMapNew(i);
    correctionBoundaryLow = max(temp1(:,[2:4]),0);
    temp1 =temp1(:,[2:4]) - 2 * correctionBoundaryLow;
    temp1 = min(temp1(:,[2:4]),repmat(observeSideLen(1),rows,3));
    clusterMolsMapNew(i) = temp1;
  end
end

function[molArrayNew,molArrayOld]=moveIndependentMol(molArrayNew, molArrayOld,stepStd,dissociationProb,observeSideLen)
  
  %move the independentMols first
  %Save the old position, then assign the new position.
  temp=size(molArrayNew);
  row = temp(1);
  col=temp(2);

  %column 1,2,3,4 is clusterid,x, y, z. Clusterid should be 0 for independent molecules.
  molArrayOld(:,[1:col]) = molArrayNew(:,[1:col]);
  receptorDisp = stepStd*randn(row,3);
  molArrayNew(:,[2:4]) = molArrayNew(:,[2:4])+receptorDisp;

  %make sure that receptors stay inside the region of interest (not below 0 and not above limit)
  correctionBoundaryLow = max(molArrayNew(:,[2:4]),0);
  molArrayNew(:,[2:4])=molArrayNew(:,[2:4]) - 2 * correctionBoundaryLow;
  correctionBoundaryHigh = min(molArrayNew(:,[2:4]),repmat(observeSideLen(1),row,3));
  molArrayNew(:,[2:4])=molArrayNew(:,[2:4]) - 2 * correctionBoundaryHigh;

end
