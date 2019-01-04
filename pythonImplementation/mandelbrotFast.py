import numpy as np
import cProfile
from numba import jit, vectorize, guvectorize, float64, complex64, int32, float32, njit
from timeit import default_timer as timer

@njit(int32(complex64, int32))
def mandelbrot(c, maxiter):
    nreal = 0
    real = 0
    imag = 0
    for n in range(maxiter):
        nreal = real * real - imag * imag + c.real
        imag = 2 * real * imag + c.imag
        real = nreal;
        if real * real + imag * imag > 4.0:
            return n
    return 0


@guvectorize([(complex64[:], int32[:], int32[:])], '(n),()->(n)', target='parallel')
def mandelbrot_numpy(c, maxit, output):
    maxiter = maxit[0]
    for i in range(c.shape[0]):
        output[i] = mandelbrot(c[i], maxiter)


def mandelbrot_set(xmin, xmax, ymin, ymax, width, height, maxiter):
    r1 = np.linspace(xmin, xmax, width, dtype=np.float32)
    r2 = np.linspace(ymin, ymax, height, dtype=np.float32)
    c = r1 + r2[:, None] * 1j
    n3 = mandelbrot_numpy(c, maxiter)
    return (r1, r2, n3.T)

start = timer()
mandelbrot_set(-2.0, 0.5, -1.25, 1.25, 1000, 1000, 80)
print(timer() - start)
start = timer()
mandelbrot_set(-0.74877,-0.74872,0.06505,0.06510,1000,1000,2048)
print(timer() - start)
