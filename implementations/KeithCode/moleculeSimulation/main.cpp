#include <bits/stdc++.h>
using namespace std;

double randRange(double observeSideLen) {
  return (0 + (rand() % (int)(observeSideLen - 0 + 1)));
}
//logic is off
double randCoordinate(double time, double diffCoef, double position) {
  double temp = sqrt(2*time*diffCoef);
  return  (position +1) + (rand() / ( RAND_MAX / (position -1 -position+1) ) ) ;
}


//add the particles to a 2d array of quadrants.
void assignPositionToArea(vector<vector<set<int>>>& quadrants, double * x, double * y, int sizeOfArray, double edgeSize, double divisions) {
  //find out how many division horizontally and vertically. This assumes the area is square.
  double divisionLength = edgeSize/divisions;

  //decide what particle belongs to what box
  for(int i=0; i< sizeOfArray; i++) {
    int row =(int) ceil(x[i]/divisionLength);
    int col= (int)ceil(y[i]/divisionLength);
    quadrants[row][col].insert(i);
    cout<<x[i]<<" "<<y[i]<<endl;
  }
}

//reassign the particles to a new quadrant. Call this after the particle's positions changed. This assumess the area is square. If it's not this can be changed later.
void diffuseOneParticle(vector<vector<set<int>>>& quadrants, double * x, double * y, double newX, double newY, int sizeOfArray, double edgeSize, double divisions) {
  double divisionLength = edgeSize/divisions;
  for(int i=0; i< sizeOfArray; i++) {
    int newRow= (int) ceil(newX/divisionLength);
    int newCol = (int) ceil(newY/divisionLength);
    int oldRow =(int) ceil(x[i]/divisionLength);
    int oldCol= (int) ceil(y[i]/divisionLength);
    quadrants[oldRow][oldCol].erase(i);
    quadrants[newRow][newCol].insert(i);

    //edge case, what if it moves out of bound?
  }
}

//generate new x and new y and reassign the particle to a new quadrant
//implement the logic for diffusing quadrants. pass in more variables to generate the random function.
//the amount of variables to pass into a function is unreal. Too much bookkeeping to be done and I can't guarantee there won't be any bug. The program will also be very difficult to maintain.


void setRandomVariable(double * position, int numberOfParticles, double observeSideLen) {
  for(int i=0; i<numberOfParticles; i++) {
    position[i] = randRange(observeSideLen);
  }
}

void diffuseQuadrants(vector<vector<set<int>>>& quadrants,double time, double diffCoef,double * x, double * y,int sizeOfArray, double observeSideLen, double divisions) {
  cout<<"$$$$$$$$$$$$$$$";
  for(int i=0; i < sizeOfArray; i++) {
    for(int j=0; j<sizeOfArray; j++) {
      for(int p : quadrants[i][j]) {
        //generate position for x and y.
        double newX= randCoordinate(time, diffCoef, x[p]);
        double newY= randCoordinate(time, diffCoef, y[p]);
        diffuseOneParticle(quadrants, x, y, newX, newY, sizeOfArray,observeSideLen,divisions);
      }

    }
  }
}
int main() {
//initiate array, set random position
  int iteration = 99999;
  double time = 10000;
  double diffCoef=1000000;
  int numberOfParticles= 100000;
  double observeSideLen = 200000;
  int divisions = 10000;

  double *xPos=new double[numberOfParticles];
  double *yPos = new double[numberOfParticles];
  vector<vector<set<int>>> quadrants;

//initialize positions
  setRandomVariable(xPos, numberOfParticles, observeSideLen);
  setRandomVariable(yPos, numberOfParticles, observeSideLen);


  cout<<"Done initializing"<<endl;
//assign positions into area.

  for(int i=0; i< divisions; i++) {
    vector<set<int>> a;
    set<int> b {};
    a.push_back(b);
    quadrants.push_back(a);
  }
  assignPositionToArea(quadrants, xPos, yPos, numberOfParticles, observeSideLen, divisions);

  cout<<"Done assigning to area."<<endl;

  for(int i=0; i<numberOfParticles; i++) {
    cout<< xPos[i] <<" "<< yPos[i]<<endl;
  }
  for(int i=0; i< iteration; i++) {
    diffuseQuadrants(quadrants,time, diffCoef, xPos, yPos, numberOfParticles,observeSideLen,divisions);
  }
  cout<<"Done simulating"<<endl;
  //print out the position arrays.


}
