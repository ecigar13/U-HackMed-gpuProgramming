import numpy as np
from numba import jit, vectorize, guvectorize, float64, complex64, int64, prange

import random, cProfile

@jit
def move3d(seed, x, y, z, deviation):
    """Return a pair of new x,y coordinate for a given input x, y based on the seed. """
    random.seed(seed)
    return random.randrange(x - deviation, x + deviation), random.randrange(y - deviation, y + deviation), \
           random.randrange(z - deviation, z + deviation)

@jit
def trueFalse(seed):
    """Return random true false based on the seed. Need to improve this probability to match Khuloud Jaquaman's matlab."""
    random.seed(seed)
    return random.getrandbits(1)


@jit
def move2d(seed, xy, deviation):
    """Return a pair of new x,y coordinate for a given input x, y based on the seed. """
    random.seed(seed)
    return random.randrange(xy[0] - deviation, xy[0] + deviation), random.randrange(xy[1] - deviation, xy[1] +
                                                                                    deviation)


@jit
def moveAllParticles2d(seed, deviation, pointArray):
    for i in prange(pointArray.size):
        #print(pointArray[i])
        pointArray[i] = move2d(seed,pointArray[i], deviation)
        #print(pointArray[i])
    return pointArray



@jit
def initiateParticles2d(numberOfParticle, bound):
    """Return a 2d array of x and y within a certain bound. The index stands for the id of particle."""
    return np.random.randint(bound, size=(numberOfParticle, 2))


@jit
def initiateParticles3d(numberOfParticle, bound):
    """Return a 2d array of x, y, z within a certain bound. The index stands for the id of particle."""
    return np.random.randint(bound, size=(numberOfParticle, 3))


##initiate a bunch of particles
##set the bounds
##move them ---> will use a lot
##associate them ---> if they do so.
##move the pairs
##disassociate the pairs.


##Associate particles

@jit
def main(numberOfParticle, bound, seed, deviation, iterations):
    molArray = initiateParticles2d(numberOfParticle,bound)
    #print(molArray)
    for i in prange(iterations):
        moveAllParticles2d(seed, deviation, molArray)
        #print(molArray)

cProfile.run("main(99999,99,1,2,10)")
