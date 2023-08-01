import numpy as np
import matplotlib.pyplot as plt

d, h = 200, 1200  # pixel density (= image width) and image height
n, r = 8000, 10000  # number of iterations and escape radius (r > 2)

a = -.743643887037158704752191506114774  # try: a, b, n = -1.748764520194788535, 3e-13, 800
b = 0.131825904205311970493132056385139  # https://mathr.co.uk/web/m-location-analysis.html

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x * np.pi, y * np.pi)
C = 8.0 * np.exp((A + B * 1j) * 1j) + (a + b * 1j)

Z, dZ = np.zeros_like(C), np.zeros_like(C)
D = np.zeros(C.shape)

for k in range(n):
    M = Z.real ** 2 + Z.imag ** 2 < r ** 2
    Z[M], dZ[M] = Z[M] ** 2 + C[M], 2 * Z[M] * dZ[M] + 1

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D.T ** 0.05, cmap=plt.cm.nipy_spectral, origin="lower")
plt.savefig("Mercator_Mandelbrot_map.png", dpi=200)

X, Y = C.real, C.imag  # zoom images (adjust circle size 100 and zoom level 20 as needed)
R, c, z = 100 * (2 / d) * np.pi * np.exp(- B), min(d, h) + 1, max(0, h - d) // 20

fig, ax = plt.subplots(2, 2, figsize=(12, 12))
ax[0,0].scatter(X[1*z:1*z+c,0:d], Y[1*z:1*z+c,0:d], s=R[0:c,0:d]**2, c=D[1*z:1*z+c,0:d]**.5, cmap=plt.cm.nipy_spectral)
ax[0,1].scatter(X[2*z:2*z+c,0:d], Y[2*z:2*z+c,0:d], s=R[0:c,0:d]**2, c=D[2*z:2*z+c,0:d]**.4, cmap=plt.cm.nipy_spectral)
ax[1,0].scatter(X[3*z:3*z+c,0:d], Y[3*z:3*z+c,0:d], s=R[0:c,0:d]**2, c=D[3*z:3*z+c,0:d]**.3, cmap=plt.cm.nipy_spectral)
ax[1,1].scatter(X[4*z:4*z+c,0:d], Y[4*z:4*z+c,0:d], s=R[0:c,0:d]**2, c=D[4*z:4*z+c,0:d]**.2, cmap=plt.cm.nipy_spectral)
plt.savefig("Mercator_Mandelbrot_zoom.png", dpi=100)
