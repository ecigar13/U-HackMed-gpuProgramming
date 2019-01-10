import numpy as np
from numba import jit, vectorize, guvectorize, float64, complex64, int64, prange, njit
import random
from memory_profiler import profile
import resource
from timeit import default_timer as timer


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


# @jit(parallel=True)
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

def main(numberOfParticle, bound, seed, deviation, iterations):
  """Do not use parallel=True here. This is sequential. Simulate movement in certain iterations."""
  molArray = initiateParticles2d(numberOfParticle, bound)
  print(molArray)
  for i in prange(iterations):
    molArray = moveAllParticles2d(seed, deviation, molArray)
  print(molArray)


start = timer()
main(10000, 999, 0, 2, 20)
print(timer() - start)
