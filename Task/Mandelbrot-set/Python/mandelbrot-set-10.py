import numba
numba.config.CUDA_ENABLE_PYNVJITLINK = True  # prevent cuda ptx version errors

import numpy as np
import matplotlib.pyplot as plt

import cupy as cp
import numba.cuda as cuda

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 80  # set precision to 80 digits (about 256 bits)

d, h = 1600, 1000  # pixel density (= image width) and image height
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

A, B = np.meshgrid(x - 1, y - h / d)
C = 5.0e-35 * (A + B * 1j)

def iteration_cupy_cuda(S, C):
    I = cp.zeros(C.shape, dtype=np.int32)
    E, Z, dZ = cp.zeros_like(C), cp.zeros_like(C), cp.zeros_like(C)

    iteration = cp.RawKernel("""
    #include <cupy/complex.cuh>

    extern "C" __global__
    void iterate(int dim_x, int dim_y, int n, double r,
        complex<double> *S, complex<double> *C,
        int *I, complex<double> *E, complex<double> *Z, complex<double> *dZ) {

        int x = blockIdx.x * blockDim.x + threadIdx.x;
        int y = blockIdx.y * blockDim.y + threadIdx.y;

        if (x < dim_x and y < dim_y) { // prevent memory access errors
            int x_y = x * dim_y + y; // cupy arrays are in row-major order
            complex<double> delta = C[x_y];

            int index = I[x_y];
            complex<double> epsilon = E[x_y];
            complex<double> z = Z[x_y];
            complex<double> dz = dZ[x_y];

            double abs2_r = r * r;
            double abs2_z, abs2_e;

            for (int i = 0;  i < n;  i++) {
                abs2_z = z.real() * z.real() + z.imag() * z.imag();
                abs2_e = epsilon.real() * epsilon.real() + epsilon.imag() * epsilon.imag();

                if (abs2_z < abs2_e) { // rebase when z is closer to zero
                    epsilon = z; index = 0; // reset reference orbit
                }
                if (abs2_z < abs2_r) {
                    epsilon = (2. * S[index] + epsilon) * epsilon + delta; index = index + 1;
                    dz = 2. * z * dz + 1.; z = S[index] + epsilon;
                }
                else {
                    break;
                }
            }
            I[x_y] = index; E[x_y] = epsilon; Z[x_y] = z; dZ[x_y] = dz;
        }
    }
    """, "iterate")

    griddim, blockdim = (h // 32 + 1, d // 32 + 1), (32, 32)
    iteration(griddim, blockdim, (h+1, d+1, n, r, cp.asarray(S), cp.asarray(C), I, E, Z, dZ))
    return I.get(), E.get(), Z.get(), dZ.get()

def iteration_numba_cuda(S, C):
    I = cp.zeros(C.shape, dtype=np.int32)
    E, Z, dZ = cp.zeros_like(C), cp.zeros_like(C), cp.zeros_like(C)

    @cuda.jit()
    def iteration(S, C, I, E, Z, dZ):
        x, y = cuda.grid(2)

        if x < h+1 and y < d+1:  # prevent memory access errors
            delta, index, epsilon, z, dz = C[x, y], I[x, y], E[x, y], Z[x, y], dZ[x, y]

            def abs2(z):
                return z.real * z.real + z.imag * z.imag

            for i in range(n):
                if abs2(z) < abs2(epsilon):  # rebase when z is closer to zero
                    index, epsilon = 0, z  # reset reference orbit
                if abs2(z) < abs2(r):
                    index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
                    z, dz = S[index] + epsilon, 2 * z * dz + 1
                else:
                    break

            I[x, y], E[x, y], Z[x, y], dZ[x, y] = index, epsilon, z, dz

    griddim, blockdim = (h // 32 + 1, d // 32 + 1), (32, 32)
    iteration[griddim, blockdim](cp.asarray(S), cp.asarray(C), I, E, Z, dZ)
    return I.get(), E.get(), Z.get(), dZ.get()

I, E, Z, dZ = iteration_numba_cuda(S, C)  # use iteration_cupy_cuda or iteration_numba_cuda
D = np.zeros(C.shape, dtype=np.float64)

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D ** 0.15, cmap=plt.cm.jet, origin="lower")
plt.savefig("Mandelbrot_deep_zoom.png", dpi=300)
