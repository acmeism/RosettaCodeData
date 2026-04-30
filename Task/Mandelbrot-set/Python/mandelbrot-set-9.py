import numba
# import cupy as cp  # import cupy for GPU calculations

import numpy as np
import matplotlib.pyplot as plt

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 40  # set precision to 40 digits (about 128 bits)

d, h = 1600, 1000  # pixel density (= image width) and image height
n, r = 50000, 10000  # number of iterations and escape radius (r > 2)

a, b = dc.Decimal("-1.39966699645936"), dc.Decimal("0.0005429083913")
radius = float("0.000000000000036") / 2  # coordinates by Aokoroko

S = np.zeros(n + 100, dtype=np.complex128)  # 100 iterations are chained
u, v = dc.Decimal(0), dc.Decimal(0)

for i in range(n + 100):
    S[i] = float(u) + float(v) * 1j
    if u * u + v * v < r * r:
        u, v = u * u - v * v + a, 2 * u * v + b
    else:
        print("The reference sequence diverges within %s iterations." % i)
        break

x = np.linspace(0, 2, num=d+1)
y = np.linspace(0, 2 * h / d, num=h+1)

A, B = np.meshgrid(x - 1, y - h / d)
C = radius * (A + B * 1j)

@numba.njit(parallel=True, fastmath=True)
def iteration_numba_bla(S, C):
    I, J = np.zeros(C.shape, dtype=np.int64), np.zeros(C.shape, dtype=np.complex128)
    E, Z = np.zeros_like(C), np.zeros_like(C)

    def iteration(S, R, A, B, C):
        I, J = np.zeros(C.shape, dtype=np.int64), np.zeros(C.shape, dtype=np.complex128)
        E, Z = np.zeros_like(C), np.zeros_like(C)

        def abs2(z):
            return z.real * z.real + z.imag * z.imag

        def iterate2(delta, index, epsilon, z):
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z = S[index] + epsilon
            return index, epsilon, z

        def skip100(delta, index, epsilon, z):
            # for k in range(100):  # skip 100 iterations (using linear approximations)
            #     index, epsilon = index + 1, 2 * S[index] * epsilon + delta
            index, epsilon = index + 100, A[index] * epsilon + B[index] * delta
            z = S[index] + epsilon
            return index, epsilon, z

        for k in range(len(C)):
            delta, index, epsilon, z = C[k], I[k], E[k], Z[k]

            i, j = 0, 0
            while i + j < n:
                if abs2(z) < abs2(r):
                    if abs2(epsilon) < abs2(1e-8 * R[index]):  # accuracy
                        index, epsilon, z = skip100(delta, index, epsilon, z)
                        j = j + 100
                    else:
                        if abs2(z) < abs2(epsilon):
                            index, epsilon = 0, z  # reset the reference orbit
                        index, epsilon, z = iterate2(delta, index, epsilon, z)
                        i = i + 2
                else:
                    break

            I[k], J[k], E[k], Z[k] = index, complex(i + j, j), epsilon, z

        return I, J, E, Z

    A, B = np.ones(n, dtype=np.complex128), np.zeros(n, dtype=np.complex128)
    R, aS = np.full(n, 2, dtype=np.float64), np.where(np.abs(S) < 2, np.abs(S), 0)

    for i in numba.prange(n):  # coefficients and radii for the bilinear approximation
        for k in range(100):
            A[i], B[i] = 2 * S[i + k] * A[i], 2 * S[i + k] * B[i] + 1
            R[i] = min(R[i], aS[i + k])  # validity radii and skip barriers (zeros)

    for i in numba.prange(C.shape[0]):
        I[i, :], J[i, :], E[i, :], Z[i, :] = iteration(S, R, A, B, C[i, :])

    return I, J, E, Z

def iteration_cupy_cuda(S, C):
    S, C = cp.asarray(S, dtype=np.complex64), cp.asarray(C, dtype=np.complex64)
    I, J = cp.zeros(C.shape, dtype=np.int32), cp.zeros(C.shape, dtype=np.float32)
    E, Z = cp.zeros_like(C), cp.zeros_like(C)

    iteration = cp.RawKernel("""
    #include <cupy/complex.cuh>

    extern "C" __global__
    void iterate(int dim_x, int dim_y, int n, int r,
        complex<float> *S, complex<float> *C,
        int *I, float *J, complex<float> *E, complex<float> *Z) {

        int x = blockIdx.x * blockDim.x + threadIdx.x;
        int y = blockIdx.y * blockDim.y + threadIdx.y;

        if (x < dim_x and y < dim_y) {
            int x_y = x * dim_y + y;  // cupy arrays are in row-major order

            complex<float> delta = C[x_y];
            int index = I[x_y];
            complex<float> e = E[x_y];
            complex<float> z = Z[x_y];

            float abs2_r = float(r) * float(r);

            int i = 0;
            while (i < n) {
                float abs2_z = z.real() * z.real() + z.imag() * z.imag();
                if (abs2_z < abs2_r) {
                    float abs2_e = e.real() * e.real() + e.imag() * e.imag();
                    if (abs2_z < abs2_e) {
                        e = z; index = 0;  // reset the reference orbit
                    }
                    e = (float(2) * S[index] + e) * e + delta; index = index + 1;
                    e = (float(2) * S[index] + e) * e + delta; index = index + 1;
                    z = S[index] + e;
                    i = i + 2;
                }
                else {
                    break;
                }
            }
            I[x_y] = index; J[x_y] = float(i); E[x_y] = e; Z[x_y] = z;
        }
    }
    """, "iterate")

    griddim, blockdim = ((C.shape[0] - 1) // 32 + 1, (C.shape[1] - 1) // 32 + 1), (32, 32)
    iteration(griddim, blockdim, (C.shape[0], C.shape[1], n, r, S, C, I, J, E, Z))
    return I.get(), J.get(), E.get(), Z.get()

I, J, E, Z = iteration_numba_bla(S, C)  # use iteration_numba_bla or iteration_cupy_cuda
T = J.real.copy()

skipped = J.imag.sum() / J.real.sum()
print("%.1f%% of all iterations were skipped." % (skipped * 100))

N = abs(Z) >= r  # normalized iteration count
T[N] = T[N] - np.log2(np.log(abs(Z[N])) / np.log(r))

T = np.maximum(n - T, 0)  # inversion and truncation
T = T / T.max()  # scaling

plt.imshow(T ** 2.0 % (1/64), cmap=plt.cm.turbo, origin="lower")
plt.savefig("Mandelbrot_deep_zoom.png", dpi=200)
