import numpy as np
from timeit import default_timer as timer
from numba import vectorize

## change CPU to CUDA or GPU
@vectorize(['float32(float32, float32)'], target='cpu')
def pow(a, b):
    return a ** b

def main():
    vec_size = 10000000

    a = b = np.array(np.random.sample(vec_size), dtype=np.float32)
    c = np.zeros(vec_size, dtype=np.float32)

    start = timer()
    c = pow(a, b)
    duration = timer() - start

    print(duration)

if __name__ == '__main__':
    main()