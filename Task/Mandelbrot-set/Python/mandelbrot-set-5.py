import numpy as np
import matplotlib.pyplot as plt

d, h = 800, 500  # pixel density (= image width) and image height
n, r = 200, 500  # number of iterations and escape radius (r > 2)

direction, height = 45, 1.5  # direction and height of the incoming light
v = np.exp(direction / 180 * np.pi * 1j)  # unit 2D vector in this direction

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x - 1, y - h / d)
C = (2.0 + 1.0j) * (A + B * 1j) - 0.5

Z, dZ, ddZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)
D, T = np.zeros(C.shape), np.zeros(C.shape)

for k in range(n):
    M = Z.real ** 2 + Z.imag ** 2 < r ** 2
    Z[M], dZ[M], ddZ[M] = Z[M] ** 2 + C[M], 2 * Z[M] * dZ[M] + 1, 2 * (dZ[M] ** 2 + Z[M] * ddZ[M])

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D ** 0.1, cmap=plt.cm.twilight_shifted, origin="lower")
plt.savefig("Mandelbrot_distance_est.png", dpi=200)

N = abs(Z) > 2  # normal map effect 1 (potential function)
U = Z[N] / dZ[N]  # normal vectors to the equipotential lines
U, S = U / abs(U), 1 + np.sin(100 * np.angle(U)) / 10  # unit normal vectors and stripes
T[N] = np.maximum((U.real * v.real + U.imag * v.imag + S * height) / (1 + height), 0)

plt.imshow(T ** 1.0, cmap=plt.cm.bone, origin="lower")
plt.savefig("Mandelbrot_normal_map_1.png", dpi=200)

N = abs(Z) > 2  # normal map effect 2 (distance estimation)
U = Z[N] * dZ[N] * ((1 + np.log(abs(Z[N]))) * np.conj(dZ[N] ** 2) - np.log(abs(Z[N])) * np.conj(Z[N] * ddZ[N]))
U = U / abs(U)  # unit normal vectors to the equidistant lines
T[N] = np.maximum((U.real * v.real + U.imag * v.imag + height) / (1 + height), 0)

plt.imshow(T ** 1.0, cmap=plt.cm.afmhot, origin="lower")
plt.savefig("Mandelbrot_normal_map_2.png", dpi=200)
