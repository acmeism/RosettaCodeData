import numpy as np
import matplotlib.pyplot as plt

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 80  # set precision to 80 digits (about 256 bits)

d, h = 50, 1000  # pixel density (= image width) and image height
n, r = 80000, 100000  # number of iterations and escape radius (r > 2)

a = dc.Decimal("-1.256827152259138864846434197797294538253477389787308085590211144291")
b = dc.Decimal(".37933802890364143684096784819544060002129071484943239316486643285025")

S = np.zeros(n+1, dtype=np.complex128)
u, v = dc.Decimal(0), dc.Decimal(0)

for k in range(n+1):
    S[k] = float(u) + float(v) * 1j
    if u ** 2 + v ** 2 < r ** 2:
        u, v = u ** 2 - v ** 2 + a, 2 * u * v + b
    else:
        print("The reference sequence diverges within %s iterations." % k)
        break

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x * np.pi, y * np.pi)
C = 8.0 * np.exp((A + B * 1j) * 1j)

E, Z, dZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)
D, I, J = np.zeros(C.shape), np.zeros(C.shape, dtype=np.int64), np.zeros(C.shape, dtype=np.int64)

for k in range(n):
    Z2 = Z.real ** 2 + Z.imag ** 2
    M, R = Z2 < r ** 2, Z2 < E.real ** 2 + E.imag ** 2
    E[R], I[R] = Z[R], J[R]  # rebase when z is closer to zero
    E[M], I[M] = (2 * S[I[M]] + E[M]) * E[M] + C[M], I[M] + 1
    Z[M], dZ[M] = S[I[M]] + E[M], 2 * Z[M] * dZ[M] + 1

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D.T ** 0.015, cmap=plt.cm.nipy_spectral, origin="lower")
plt.savefig("Mercator_Mandelbrot_deep_map.png", dpi=200)
