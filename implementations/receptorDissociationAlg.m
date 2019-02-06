function [cluster2receptor,receptor2cluster,clusterSize] = receptorDissociationAlg(...
  molArrayNew,molArrayOld,clusterMolsMapOld, clusterMolsMapNew, dissociationProb)

  %matlab doesn't allow chaining command.
  clusterIds=keys(clusterMolsMapNew);
  clusterMembers=values(clusterMolsMapNew);
  clusterMolsMapOld=clusterMolsMapNew;
  
  %if there's no cluster:
  if(length(clusterIds)==1)  %there's only an initial key value pair.
    return
  end
  
  molArrayOld(:,[1:col]) = molArrayNew(:,[1:col]);
  %copy some input variables for modification and output
 
  %06/27/13 (1 of 2)
  %{
  dissociationProb used on clusters instead of receptors (above).
  Probability can be determined in two ways:  a single value for all current
  clusters or each cluster has its own value. For a dissociating cluster, a
  receptor will be randomly picked and removed from the cluster (below).
  Dissociation happens one receptor at a time. 
  %}
  %Each cluster has its own value
  

  %go over these clusters
  
  for iCluster = clustersBig'

      %get receptors belonging to this cluster
      

      %06/27/13 (2 of 2)
      %For a cluster that is dissociating, determine which receptor to
      %dissociate by randomly picking one of the receptors.
      
      if (clusterDissociateFlag(iCluster))
          %Current cluster is dissociating. Pick a random integer between 1
          %and number of receptors in cluster.
          
          %Set the flag for picked receptor to 1.
          
      end
      
      %if all receptors want to dissociate, assign the first one a flag
      %of 0 (just for algorithmic reasons)
      

      %remove receptors that want to dissocate from cluster
      

      %append to the end of the cluster vector those receptors that dissociated
      

      %keep the receptors that did not dissociate in their proper cluster
      
      %update vector storing for every receptor its cluster number
      
  end

  %remove empty row and columns and get final number of clusters
  

  %copy temporary variable into output variables
  

end