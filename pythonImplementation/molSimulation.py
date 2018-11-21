import numpy as np
import scipy
from numba import jit, vectorize, guvectorize, float64, complex64, int64

import random, cProfile


@jit
def trueFalse(seed):
    """Return random true false based on the seed. Need to improve this probability to match Khuloud Jaquaman's matlab."""
    random.seed(seed)
    return random.getrandbits(1)


@jit
def move2d(seed, x, y, deviation):
    """Return a pair of new x,y coordinate for a given input x, y based on the seed. """
    random.seed(seed)
    return random.randrange(x - deviation, x + deviation), random.randrange(y - deviation, y + deviation)


@jit
def move3d(seed, x, y, z, deviation):
    """Return a pair of new x,y coordinate for a given input x, y based on the seed. """
    random.seed(seed)
    return random.randrange(x - deviation, x + deviation), random.randrange(y - deviation, y + deviation), \
           random.randrange(z - deviation, z + deviation)


@jit
def initiateParticles2d(numberOfParticle, bound):
    """Return a 2d array of x and y within a certain bound. The index stands for the id of particle."""
    return np.random.randint(bound, size=(numberOfParticle,2))

@jit
def initiateParticles2d(numberOfParticle, bound):
    """Return a 2d array of x, y, z within a certain bound. The index stands for the id of particle."""
    return np.random.randint(bound, size=(numberOfParticle,3))


cProfile.run("initiateParticles2d(9999,9)")
##initiate a bunch of particles
##set the bounds
##move them ---> will use a lot
##associate them ---> if they do so.
##move the pairs
##disassociate the pairs.
