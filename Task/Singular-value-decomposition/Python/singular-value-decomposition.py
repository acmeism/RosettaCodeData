from numpy import *
A = matrix([[3, 0], [4, 5]])
U, Sigma, VT = linalg.svd(A)
print(U)
print(Sigma)
print(VT)
