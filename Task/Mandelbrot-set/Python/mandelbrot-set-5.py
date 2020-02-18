import matplotlib.pyplot as plt


def linspace(start, stop, num):
    return [start + (stop - start) / (num - 1) * k for k in range(num)]


def zeros(rows, cols):
    return [[0 for j in range(cols)] for i in range(rows)]


d, n = 100, 50  # pixel density & number of iterations
r = 2.5  # escape radius (must be greater than 2)

x = linspace(-2.5, 1.5, 4 * d + 1)
y = linspace(-1.5, 1.5, 3 * d + 1)

T = zeros(len(y), len(x))

for i, b in enumerate(y):
    for j, a in enumerate(x):
        u, v = 0.0, 0.0
        for k in range(n):
            u, v = u ** 2 - v ** 2 + a, 2 * u * v + b
            if not u ** 2 + v ** 2 < r ** 2:
                break
        T[i][j] = k + 1

plt.imshow(T, cmap=plt.cm.twilight_shifted)
plt.savefig("mandelbrot.png", dpi=200)
