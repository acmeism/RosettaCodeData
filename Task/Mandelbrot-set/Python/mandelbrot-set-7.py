import numpy as np
import matplotlib.pyplot as plt

d, h = 200, 1200  # pixel density (= image width) and image height
n, r = 8000, 10000  # number of iterations and escape radius (r > 2)

a = -.743643887037158704752191506114774  # coordinates by github.com/josch
b = 0.131825904205311970493132056385139  # https://github.com/josch/mandelbrot

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x * np.pi, y * np.pi)
C = 8.0 * np.exp((A + B * 1j) * 1j) + (a + b * 1j)

def iteration(C):
    Z, dZ = np.zeros_like(C), np.zeros_like(C)

    def iterate(C, Z, dZ):
        Z, dZ = Z * Z + C, 2 * Z * dZ + 1
        return Z, dZ

    for i in range(n):
        M = abs(Z) < r
        Z[M], dZ[M] = iterate(C[M], Z[M], dZ[M])

    return Z, dZ

Z, dZ = iteration(C)
D = np.zeros(C.shape)

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D.T ** 0.05, cmap=plt.cm.nipy_spectral, origin="lower")
plt.savefig("Mercator_Mandelbrot_map.png", dpi=200)

M = 50 * (2 / d) * np.pi * np.exp(- B)  # adjust marker size 50 as needed
k, l = min(d, h) + 1, max(0, h - d) // 20  # adjust zoom level 20 as needed

fig, axs = plt.subplots(2, 3, figsize=(12, 8))
for i, ax in enumerate(axs.flat):
    X, Y = C[i*l:i*l+k, 0:d].real, C[i*l:i*l+k, 0:d].imag
    S, T = M[0:k, 0:d] ** 2, D[i*l:i*l+k, 0:d] ** 0.5
    ax.scatter(X, Y, s=S, c=T, cmap=plt.cm.nipy_spectral)
    ax.axis('equal')

plt.savefig("Mercator_Mandelbrot_zoom.png", dpi=100)
