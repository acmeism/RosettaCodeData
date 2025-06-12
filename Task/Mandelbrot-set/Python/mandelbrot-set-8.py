import numpy as np
import numba as nb
import matplotlib.pyplot as plt

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 80  # set precision to 80 digits (about 256 bits)

d, h = 100, 2000  # pixel density (= image width) and image height
n, r = 80000, 100000  # number of iterations and escape radius (r > 2)

a = dc.Decimal("-1.256827152259138864846434197797294538253477389787308085590211144291")
b = dc.Decimal(".37933802890364143684096784819544060002129071484943239316486643285025")

S = np.zeros(n+1, dtype=np.complex128)
u, v = dc.Decimal(0), dc.Decimal(0)

for k in range(n+1):
    S[k] = float(u) + float(v) * 1j
    if u * u + v * v < r * r:
        u, v = u * u - v * v + a, 2 * u * v + b
    else:
        print("The reference sequence diverges within %s iterations." % k)
        break

x = np.linspace(0, 2, num=d+1, dtype=np.float64)
y = np.linspace(0, 2 * h / d, num=h+1, dtype=np.float64)

A, B = np.meshgrid(x * np.pi, y * np.pi)
C = (- 8.0) * np.exp((A + B * 1j) * 1j)

@nb.njit(parallel=True)
def calculation(C):
    E, I = np.zeros_like(C), np.zeros(C.shape, dtype=np.int64)
    Z, dZ = np.zeros_like(C), np.zeros_like(C)

    def iteration(C):
        E, I = np.zeros_like(C), np.zeros(C.shape, dtype=np.int64)
        Z, dZ = np.zeros_like(C), np.zeros_like(C)

        def abs2(z):
            return z.real * z.real + z.imag * z.imag

        def iterate(E, I, Z, dZ, C):
            E, I = (2 * S[I] + E) * E + C, I + 1
            Z, dZ = S[I] + E, 2 * Z * dZ + 1
            return E, I, Z, dZ

        for k in range(n):
            M = abs2(Z) < abs2(E)
            E[M], I[M] = Z[M], 0  # rebase when z is closer to zero
            M = abs2(Z) < abs2(r)
            E[M], I[M], Z[M], dZ[M] = iterate(E[M], I[M], Z[M], dZ[M], C[M])

        return E, I, Z, dZ

    for j in nb.prange(C.shape[1]):
        E[:,j], I[:,j], Z[:,j], dZ[:,j] = iteration(C[:,j])

    return E, I, Z, dZ

E, I, Z, dZ = calculation(C)
D = np.zeros(C.shape, dtype=np.float64)

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D.T ** 0.015, cmap=plt.cm.gist_ncar, origin="lower")
plt.savefig("Mercator_Mandelbrot_deep_map.png", dpi=200)
