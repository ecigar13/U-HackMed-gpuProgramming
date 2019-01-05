

#include <bits/stdc++.h>
#include <iostream>
using namespace std;

//get a random number, compare it to the probability.
bool random(double prob) {
  srand (time(NULL));
  double i = ((double) rand() / (RAND_MAX)) ;
  //cout << i <<" \n";
  if (i > prob) {
    return true;
  } else
    return false;
}

void dissociateParticle(vector<int>& particle2Cluster,vector<vector<int>>& cluster2Receptor, double dissociationProb) {

  //which one to disassociate
  for(int cluster=0; cluster < cluster2Receptor.size(); cluster++) {
    if(random(dissociationProb)) {
      for(int j =0; j< cluster2Receptor[cluster].size(); j++) {
        if(random(dissociationProb)) {
          //set the particle free and change it in the cluster2Receptor.
          int temp = cluster2Receptor[cluster][j];
          cluster2Receptor[cluster][j] = 0;
          particle2Cluster[temp] = temp;
          cout<<temp<<" \n";

          //Implement: if the cluster is empty or only has 1 element, don't remove it. ??
        }
      }
    }
  }
}
int main() {

  cout << "Hello world!" << endl;

  vector<vector<int>> cluster2Receptor{ { 1,2},{3,4}};
  vector<int> receptor2Cluster {1,1,3,3,5,6,7,8,9};
  dissociateParticle(receptor2Cluster,cluster2Receptor,0.5);

  for(int i : receptor2Cluster) {
    cout<< i<< " ";
  }
  cout<< "\n";
  for(int i=0; i<cluster2Receptor.size(); i++) {
    for(int j=0; j<cluster2Receptor[i].size(); j++) {
      cout<< cluster2Receptor[i][j]<< " ";
    }
  }

  return 0;
}


