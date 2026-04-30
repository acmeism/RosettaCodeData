import numba
# import numba.cuda as cuda  # import numba.cuda for GPU calculations

import numpy as np
import matplotlib.pyplot as plt

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 80  # set precision to 80 digits (about 256 bits)

d, h = 100, 2000  # pixel density (= image width) and image height
n, r = 100000, 10000  # number of iterations and escape radius (r > 2)

a = dc.Decimal("-1.256827152259138864846434197797294538253477389787308085590211144291")
b = dc.Decimal(".37933802890364143684096784819544060002129071484943239316486643285025")

S = np.zeros(n + 2, dtype=np.complex128)  # 2 iterations are chained
u, v = dc.Decimal(0), dc.Decimal(0)

for i in range(n + 2):
    S[i] = float(u) + float(v) * 1j
    if u * u + v * v < r * r:
        u, v = u * u - v * v + a, 2 * u * v + b
    else:
        print("The reference sequence diverges within %s iterations." % i)
        break

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x * np.pi, y * np.pi)
C = (- 8.0) * np.exp((A + B * 1j) * 1j)

@numba.njit(parallel=True)
def iteration_numba(S, C):
    I = np.zeros(C.shape, dtype=np.int64)
    E, Z, dZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)

    def iteration(S, C):
        I = np.zeros(C.shape, dtype=np.int64)
        E, Z, dZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)

        def abs2(z):
            return z.real * z.real + z.imag * z.imag

        def iterate2(delta, index, epsilon, z, dz):
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z, dz = S[index] + epsilon, 2 * z * dz + 1
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z, dz = S[index] + epsilon, 2 * z * dz + 1
            return index, epsilon, z, dz

        for k in range(len(C)):
            delta, index, epsilon, z, dz = C[k], I[k], E[k], Z[k], dZ[k]

            for i in range(0, n, 2):
                if abs2(z) < abs2(r):
                    if abs2(z) < abs2(epsilon):
                        index, epsilon = 0, z  # reset the reference orbit
                    index, epsilon, z, dz = iterate2(delta, index, epsilon, z, dz)
                else:
                    break

            I[k], E[k], Z[k], dZ[k] = index, epsilon, z, dz

        return I, E, Z, dZ

    for j in numba.prange(C.shape[1]):
        I[:, j], E[:, j], Z[:, j], dZ[:, j] = iteration(S, C[:, j])

    return I, E, Z, dZ

def iteration_numba_cuda(S, C):
    I = np.zeros(C.shape, dtype=np.int64)
    E, Z, dZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)

    @cuda.jit()
    def iteration(S, C, I, E, Z, dZ):

        def abs2(z):
            return z.real * z.real + z.imag * z.imag

        def iterate2(delta, index, epsilon, z, dz):
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z, dz = S[index] + epsilon, 2 * z * dz + 1
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z, dz = S[index] + epsilon, 2 * z * dz + 1
            return index, epsilon, z, dz

        x, y = cuda.grid(2)
        if x < C.shape[0] and y < C.shape[1]:
            delta, index, epsilon, z, dz = C[x, y], I[x, y], E[x, y], Z[x, y], dZ[x, y]

            for i in range(0, n, 2):
                if abs2(z) < abs2(r):
                    if abs2(z) < abs2(epsilon):
                        index, epsilon = 0, z  # reset the reference orbit
                    index, epsilon, z, dz = iterate2(delta, index, epsilon, z, dz)
                else:
                    break

            I[x, y], E[x, y], Z[x, y], dZ[x, y] = index, epsilon, z, dz

    griddim, blockdim = ((C.shape[0] - 1) // 32 + 1, (C.shape[1] - 1) // 32 + 1), (32, 32)
    I, E, Z, dZ = cuda.to_device(I), cuda.to_device(E), cuda.to_device(Z), cuda.to_device(dZ)
    iteration[griddim, blockdim](cuda.to_device(S), cuda.to_device(C), I, E, Z, dZ)
    return I.copy_to_host(), E.copy_to_host(), Z.copy_to_host(), dZ.copy_to_host()

I, E, Z, dZ = iteration_numba(S, C)  # use iteration_numba or iteration_numba_cuda
D = np.zeros(C.shape)

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D.T ** 0.015, cmap=plt.cm.gist_ncar, origin="lower")
plt.savefig("Mercator_Mandelbrot_deep_map.png", dpi=200)
