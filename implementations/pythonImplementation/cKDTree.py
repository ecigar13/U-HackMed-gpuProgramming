import numpy as np
import scipy.spatial as spatial
from timeit import default_timer as time
import matplotlib.pyplot as plt
import resource
from numba import njit, jit

#@njit(parallel=True)
def test():
  resource.setrlimit(resource.RLIMIT_DATA, (10000000000, 10000000000))
  start = time()
  np.random.seed(2015)
  centers = np.random.rand(2000,2)
  points = np.concatenate([pt+np.random.random((10, 2))*0.5
                           for pt in centers])
  point_tree = spatial.cKDTree(points)

  cmap = plt.get_cmap('copper')
  colors = cmap(np.linspace(0, 1, len(centers)))
  for center, group, color  in zip(centers, point_tree.query_ball_point(centers, 0.5), colors):
     cluster = point_tree.data[group]
     x, y = cluster[:, 0], cluster[:, 1]
     plt.scatter(x, y, c=color, s=50)

  print(time() - start)
  plt.show()


test()
