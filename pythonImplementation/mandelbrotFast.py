import numpy as np

import timeit
import numpy as np
import cProfile
from matplotlib import pyplot as plt
from matplotlib import colors

from numba import jit


@jit
def mandelbrot(c, maxiter):
    z = c
    for n in range(maxiter):
        if abs(z) > 2:
            return n
        z = z * z + c
    return 0


@jit
def mandelbrot_set(xmin, xmax, ymin, ymax, width, height, maxiter):
    r1 = np.linspace(xmin, xmax, width)
    r2 = np.linspace(ymin, ymax, height)
    n3 = np.empty((width, height))
    for i in range(width):
        for j in range(height):
            n3[i, j] = mandelbrot(r1[i] + 1j * r2[j], maxiter)
    return (r1, r2, n3)


cProfile.run('mandelbrot_set(-2.0, 0.5, -1.25, 1.25, 1000, 1000, 80)')
cProfile.run('mandelbrot_set(-0.74877,-0.74872,0.06505,0.06510,1000,1000,2048)')
