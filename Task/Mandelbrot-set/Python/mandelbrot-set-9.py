import jax
jax.config.update("jax_enable_x64", True)  # faster on GPU P100 than on GPU T4

import numpy as np
import matplotlib.pyplot as plt

import cupy as cp
import jax.numpy as jnp

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 80  # set precision to 80 digits (about 256 bits)

d, h = 100, 2000  # pixel density (= image width) and image height
n, r = 100000, 100000.0  # number of iterations and escape radius (r > 2)

a = dc.Decimal("-1.256827152259138864846434197797294538253477389787308085590211144291")
b = dc.Decimal(".37933802890364143684096784819544060002129071484943239316486643285025")

S = np.zeros(n+1, dtype=np.complex128)
u, v = dc.Decimal(0), dc.Decimal(0)

for i in range(n+1):
    S[i] = float(u) + float(v) * 1j
    if u * u + v * v < r * r:
        u, v = u * u - v * v + a, 2 * u * v + b
    else:
        print("The reference sequence diverges within %s iterations." % i)
        break

x = np.linspace(0, 2, num=d+1, dtype=np.float64)
y = np.linspace(0, 2 * h / d, num=h+1, dtype=np.float64)

A, B = np.meshgrid(x * np.pi, y * np.pi)
C = (- 8.0) * np.exp((A + B * 1j) * 1j)

def iteration_cupy(S, C):

    def iteration(S, C):
        I = cp.zeros(C.shape, dtype=np.intp)
        E, Z, dZ = cp.zeros_like(C), cp.zeros_like(C), cp.zeros_like(C)

        for i in range(n):
            M = cp.absolute(Z) < cp.absolute(E)  # rebase when z is closer to zero
            I, E = cp.where(M, 0, I), cp.where(M, Z, E)  # reset reference orbit
            M = cp.absolute(Z) < r
            I, E = cp.where(M, I + 1, I), cp.where(M, (2 * S[I] + E) * E + C, E)
            Z, dZ = cp.where(M, S[I] + E, Z), cp.where(M, 2 * Z * dZ + 1, dZ)

        return I, E, Z, dZ

    I, E, Z, dZ = iteration(cp.asarray(S), cp.asarray(C))
    return I.get(), E.get(), Z.get(), dZ.get()

def iteration_jax(S, C):

    def iteration(S, C):
        I = jnp.zeros(C.shape, dtype=np.intp)
        E, Z, dZ = jnp.zeros_like(C), jnp.zeros_like(C), jnp.zeros_like(C)

        def abs2(z):
            return z.real * z.real + z.imag * z.imag

        def iterate(i, V):
            I, E, Z, dZ = V
            M = abs2(Z) < abs2(E)  # rebase when z is closer to zero
            I, E = jnp.where(M, 0, I), jnp.where(M, Z, E)  # reset reference orbit
            M = abs2(Z) < abs2(r)
            I, E = jnp.where(M, I + 1, I), jnp.where(M, (2 * S[I] + E) * E + C, E)
            Z, dZ = jnp.where(M, S[I] + E, Z), jnp.where(M, 2 * Z * dZ + 1, dZ)
            return I, E, Z, dZ

        I, E, Z, dZ = jax.lax.fori_loop(0, n, iterate, (I, E, Z, dZ), unroll=10)
        return I, E, Z, dZ

    I, E, Z, dZ = iteration(jnp.asarray(S), jnp.asarray(C))
    return np.asarray(I), np.asarray(E), np.asarray(Z), np.asarray(dZ)

I, E, Z, dZ = iteration_jax(S, C)  # use iteration_cupy or iteration_jax
D = np.zeros(C.shape, dtype=np.float64)

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D.T ** 0.015, cmap=plt.cm.gist_ncar, origin="lower")
plt.savefig("Mercator_Mandelbrot_deep_map.png", dpi=200)
