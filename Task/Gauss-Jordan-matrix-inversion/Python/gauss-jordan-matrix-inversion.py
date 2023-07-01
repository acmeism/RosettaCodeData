import numpy as np
from numpy.linalg import inv
a = np.array([[1., 2., 3.], [4., 1., 6.],[ 7., 8., 9.]])
ainv = inv(a)

print(a)
print(ainv)
