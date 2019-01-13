import numpy as np
from numba import jit, vectorize, guvectorize, float64, complex64, int64, prange, njit
import random
from memory_profiler import profile
import resource
from timeit import default_timer as timer


''' General layout:
get input - what input? 
create array n x 3: molecules id, x, y, cluster id
Keep track: max cluster id (for new cluster, just get a new number. Non duplicate)

need:
set memory limit

function to random x, y,z movement
function to bounce the particles
function radix/counting sort on x, y, z or cluster id
function merge sort on x, y, z or cluster id
function generate random number
function random associate within range. Return true, false
function to update the ids, keep track of active clusters

function save array to file

'''
def printParams(modelParam,simParam):
  '''print the parameters in an easy to read way'''
  print('=========================================================================');
  print('diffCoeff = {:}                           |   probDim = {:}'.format(modelParam['diffCoef'],simParam['probDim']));
  print('receptorDensity = {:}                       |   observeSideLen = {:}'.format(modelParam['receptorDensity'],simParam['observeSideLen']));
  print('aggregationProb = {:}      |   timeStep = {:}'.format(modelParam['aggregationProb'],simParam['timeStep']));
  print('aggregationDist = {:}                    |   simTime = {:}'.format(modelParam['aggregationDist'],simParam['simTime']));
  print('dissociationRate = {:}                      |   initTime = {:}         '.format(modelParam['dissociationRate'],simParam['initTime']));
  print('labelRatio = [{:}]                          |   randNumGenSeed = {:}   '.format(modelParam['labelRatio'],simParam['randNumGenSeeds']));
  print('intensityQuantum = {:}                |                         '.format(modelParam['intensityQuantum']));
  print('=========================================================================');


def main(runIndex,receptorDensity,aggregationProb,dissRate):
  '''main entry point to the simulation'''
  resource.setrlimit(resource.RLIMIT_DATA, (12000000000,12000000000))   ##12gb limit.
  print(resource.getrlimit(resource.RLIMIT_DATA))
  modelParam = {'diffCoef':0.1,
  'receptorDensity':receptorDensity,
  'aggregationProb': [0, aggregationProb,aggregationProb,aggregationProb,aggregationProb, 0],
  'aggregationDist':0.01,
  'dissociationRate':dissRate,
  'labelRatio':1,
  'intensityQuantum':[1, 0.3]}

  f = open('allRN_30.txt', 'r')
  allRN_30 = f.readlines()
  f.close()
  simParam={'probDim':2,  'observeSideLen':25,  'timeStep':0.01,  'simTime':10,  'initTime':10,
  'randNumGenSeeds':allRN_30[runIndex]}
  
  printParams(modelParam,simParam)

  start=timer()
  receptorInfoAll,receptorInfoLabeled,~,~,assocStats,collProbStats = receptorAggregationSimple_new(modelParam,simParam);
  print('=========================================================================');
  print('Elapsed time: ' timer() - start)
  print('=========================================================================');
main(1,1,1,1)