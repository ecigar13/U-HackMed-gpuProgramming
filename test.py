import numpy as np
from timeit import Timer, default_timer as timer
import operator
import resource, random

rsrc = resource.RLIMIT_DATA
soft, hard = resource.getrlimit(rsrc)
print ('Soft limit starts as  :', soft)
resource.setrlimit(rsrc, (10000000000, hard)) #limit to one kilobyte
soft, hard = resource.getrlimit(rsrc)
print( 'Soft limit changed to :', soft)

N=10000

nump_arr = np.ones([N,N])
nump_arr1 = np.ones([N,N])
li = nump_arr.tolist()
li1=nump_arr1.tolist()


def python_for():
    return map(operator.__add__,li,li1)

def numpy_add():
    return nump_arr + nump_arr1

print(min(Timer(python_for).repeat(10, 10)))
print(min(Timer(numpy_add).repeat(10, 10)))
