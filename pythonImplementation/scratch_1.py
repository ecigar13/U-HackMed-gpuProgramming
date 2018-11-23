from numba import njit, prange, jit
import numpy as np


# example of parallel numba. Use 100% of all cores
@njit(parallel=True)
def two_d_array_reduction_prod(n):
    shp = (13, 17)
    result1 = 2 * np.ones(shp, np.int_)
    tmp = 2 * np.ones_like(result1)

    for i in prange(n):
        result1 *= tmp

    return result1


@jit(nopython=True)
def bug_test(pos1):
    for i in range(pos1.shape[0]):
        for j in range(pos1.shape[1]):
            xyz = pos1[i, j]


p1 = np.random.uniform(-10, 10, (20, 3))
bug_test(p1)

two_d_array_reduction_prod(99999999)
