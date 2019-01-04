import numpy as np
from timeit import default_timer as timer
from numba import vectorize, jit, autojit, njit, float32
from memory_profiler import profile
import tensorflow as tf


## change CPU to CUDA or GPU
@vectorize(['float64(float64, float64)'], target='cuda')
def pow(a, b):
  return a ** b


@njit(parallel=True)
def pow1(a, b):
  return a ** b

@profile
def numba(vecSize):
  a = b = np.array(np.random.rand(vecSize, vecSize), dtype=np.float64)

  start = timer()
  c = pow(a, b)
  duration = timer() - start
  print(duration)

  start = timer()
  c = pow1(a, b)
  duration = timer() - start
  print(duration)

@profile
def tensor(vecSize):
  a = b = np.array(np.random.rand(vecSize * vecSize), dtype=np.float64)

  a = tf.convert_to_tensor(a, dtype=tf.float64)
  b= tf.convert_to_tensor(b,dtype=tf.float64)
  print(a.shape)
  start = timer()
  c = tf.multiply(a, b)
  print(timer() - start)


def main():
  vecSize = 10000
  numba(vecSize)
  tensor(vecSize)


if __name__ == '__main__':
  main()
