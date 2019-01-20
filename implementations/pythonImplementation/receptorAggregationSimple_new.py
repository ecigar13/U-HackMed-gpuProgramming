import numpy as np
from numba import jit, vectorize, guvectorize, float64, complex64, int64, prange, njit
import random, math
from memory_profiler import profile
import resource
from timeit import default_timer as timer

@jit(parallel=True)
def move(seed, deviation):
  '''Return a random number to move'''
  return random.randrange(deviation)

@jit(parallel=True)
def move3d(seed, x, y, z, deviation):
  """Return a pair of new x,y coordinate for a given input x, y based on the seed. """
  random.seed(seed)
  return random.randrange(x - deviation, x + deviation), random.randrange(y - deviation,
                                                                          y + deviation), random.randrange(
    z - deviation, z + deviation)


@jit(parallel=True)
def trueFalse(seed):
  """Return random true false based on the seed. Need to improve this probability to match Khuloud Jaquaman's matlab."""
  random.seed(seed)
  return random.getrandbits(1)


@jit(parallel=True)
def moveAllParticles2d(seed, deviation, pointArray):
  for i in range(pointArray.shape[0]):
    for j in range(pointArray.shape[1]):
      pointArray[i, j] += random.randrange(-deviation, deviation)
  return pointArray


@jit(parallel=True)
def initiateParticles2d(numberOfParticle, bound):
  """Return a 2d array of x and y within a certain bound. The index stands for the id of particle."""
  return np.random.randint(bound, size=(numberOfParticle, 2), dtype=np.int64)


def initiateParticles3d(numberOfParticle, bound):
  """Return a 2d array of x, y, z within a certain bound. The index stands for the id of particle."""
  return np.random.randint(bound, size=(numberOfParticle, 3), dtype=np.int64)


##initiate a bunch of particles
##set the bounds
##move them ---> will use a lot
##associate them ---> if they do so.
##dissociationProb = dissociationRate * timeStep;
##rng(randNumGenSeeds(1),'twister')
##move the pairs
##disassociate the pairs.


##Associate particles

def receptorAggregationSimple_new(modelParam, simParam):
  """Unpack modelParam and simParam dict: numberOfParticle, bound, seed, deviation, iterations"""
  '''modelParam = {'diffCoef': 0.1,
                'receptorDensity': receptorDensity,
                'aggregationProb': [0, aggregationProb, aggregationProb, aggregationProb, aggregationProb, 0],
                'aggregationDist': 0.01,
                'dissociationRate': dissRate,
                'labelRatio': 1,
                'intensityQuantum': [1, 0.3]}
  
  simParam = {'probDim': 2, 'observeSideLen': 25, 'timeStep': 0.01, 'simTime': 10, 'initTime': 10,
              'randNumGenSeeds': allRN_30[runIndex]}'''
  
  #determine number of iterations to perform
  totalTime = simParam['simTime'] * simParam['initTime']
  numIterSim = math.ceil(simParam['simTime'] / simParam['timeStep']) + 1
  numIterInit = math.ceil(simParam['initTime'] / simParam['timeStep'])
  numIterations = numIterSim + numIterInit

  #calculate dissociation probability
  dissociationProb = modelParam['dissociationRate'] * simParam['timeStep']
  #matlab code picks 1. Python uses mersenne twister by default.
  random.seed(simParam['randNumGenSeeds'][1])

  for i in range(numIterations):
    print('Iteration ' + str(i) + ' out of ' + str(numIterations))
    ## do iteration



#start = timer()
#main(10000, 999, 0, 2, 20)
#print(timer() - start)
