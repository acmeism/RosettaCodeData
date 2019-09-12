import matplotlib.pyplot as plt
import numpy as np

npts = 300
max_iter = 100

X = np.linspace(-2, 1, 2 * npts)
Y = np.linspace(-1, 1, npts)

#broadcast X to a square array
C = X[:, None] + 1J * Y
#initial value is always zero
Z = np.zeros_like(C)

exit_times = max_iter * np.ones(C.shape, np.int32)
mask = exit_times > 0

for k in range(max_iter):
    Z[mask] = Z[mask] * Z[mask] + C[mask]
    mask, old_mask = abs(Z) < 2, mask
    #use XOR to detect the area which has changed
    exit_times[mask ^ old_mask] = k

plt.imshow(exit_times.T,
           cmap=plt.cm.prism,
           extent=(X.min(), X.max(), Y.min(), Y.max()))
