import numpy as np
import matplotlib.pyplot as plt

d, h = 800, 500  # pixel density (= image width) and image height
n, r = 200, 500  # number of iterations and escape radius (r > 2)

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x - 1, y - h / d)
C = 2.0 * (A + B * 1j) - 0.5

def iteration(C):
    S, T = np.zeros(C.shape), np.zeros(C.shape)
    Z, dZ = np.zeros_like(C), np.zeros_like(C)

    def iterate(C, S, T, Z, dZ):
        S, T = S + np.exp(- abs(Z)), T + 1
        Z, dZ = Z * Z + C, 2 * Z * dZ + 1
        return S, T, Z, dZ

    for i in range(n):
        M = abs(Z) < r
        S[M], T[M], Z[M], dZ[M] = iterate(C[M], S[M], T[M], Z[M], dZ[M])

    return S, T, Z, dZ

S, T, Z, dZ = iteration(C)
D = np.zeros(C.shape)

plt.imshow(S ** 0.1, cmap=plt.cm.twilight_shifted, origin="lower")
plt.savefig("Mandelbrot_set_1.png", dpi=200)

N = abs(Z) >= r  # normalized iteration count
T[N] = T[N] - np.log2(np.log(abs(Z[N])) / np.log(r))

plt.imshow(T ** 0.1, cmap=plt.cm.twilight_shifted, origin="lower")
plt.savefig("Mandelbrot_set_2.png", dpi=200)

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D ** 0.1, cmap=plt.cm.twilight_shifted, origin="lower")
plt.savefig("Mandelbrot_set_3.png", dpi=200)

N, thickness = D > 0, 0.01  # boundary detection
D[N] = np.maximum(1 - D[N] / thickness, 0)

plt.imshow(D ** 2.0, cmap=plt.cm.binary, origin="lower")
plt.savefig("Mandelbrot_set_4.png", dpi=200)
