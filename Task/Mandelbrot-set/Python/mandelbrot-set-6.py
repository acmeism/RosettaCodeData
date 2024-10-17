import numpy as np
import matplotlib.pyplot as plt

d, h = 800, 500  # pixel density (= image width) and image height
n, r = 200, 500  # number of iterations and escape radius (r > 2)

direction, height = 45.0, 1.5  # direction and height of the light
density, intensity = 4.0, 0.5  # density and intensity of the stripes

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x - 1, y - h / d)
C = (2.0 + 1.0j) * (A + B * 1j) - 0.5

Z, dZ, ddZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)
D, S, T = np.zeros(C.shape), np.zeros(C.shape), np.zeros(C.shape)

for k in range(n):
    M = abs(Z) < r
    S[M], T[M] = S[M] + np.sin(density * np.angle(Z[M])), T[M] + 1
    Z[M], dZ[M], ddZ[M] = Z[M] ** 2 + C[M], 2 * Z[M] * dZ[M] + 1, 2 * (dZ[M] ** 2 + Z[M] * ddZ[M])

N = abs(Z) >= r  # basic normal map effect and stripe average coloring (potential function)
P, Q = S[N] / T[N], (S[N] + np.sin(density * np.angle(Z[N]))) / (T[N] + 1)
U, V = Z[N] / dZ[N], 1 + (np.log2(np.log(abs(Z[N])) / np.log(r)) * (P - Q) + Q) * intensity
U, v = U / abs(U), np.exp(direction / 180 * np.pi * 1j)  # unit normal vectors and light vector
D[N] = np.maximum((U.real * v.real + U.imag * v.imag + V * height) / (1 + height), 0)

plt.imshow(D ** 1.0, cmap=plt.cm.bone, origin="lower")
plt.savefig("Mandelbrot_normal_map_1.png", dpi=200)

N = abs(Z) > 2  # advanced normal map effect using higher derivatives (distance estimation)
H, K, L = abs(Z[N] / dZ[N]), abs(dZ[N] / ddZ[N]), np.log(abs(Z[N]))
U = Z[N] / dZ[N] - (H / K) ** 2 * L / (1 + L) * dZ[N] / ddZ[N]
U, v = U / abs(U), np.exp(direction / 180 * np.pi * 1j)  # unit normal vectors and light vector
D[N] = np.maximum((U.real * v.real + U.imag * v.imag + height) / (1 + height), 0)

plt.imshow(D ** 1.0, cmap=plt.cm.afmhot, origin="lower")
plt.savefig("Mandelbrot_normal_map_2.png", dpi=200)
