import math

def grad_g(p: list[float]):
    z = [0] * len(p)
    x = p[0]
    y = p[1]

    z[0] = 2 * (x - 1) * math.exp(-y * y) - 4 * x * math.exp(-2 * x * x) * y * (y + 2)
    z[1] = (
        -2 * (x - 1) * (x - 1) * y * math.exp(-y * y)
        + math.exp(-2 * x * x) * (y + 2)
        + math.exp(-2 * x * x) * y
    )

    return z


def g(x: list[float]):
    return (x[0] - 1) * (x[0] - 1) * math.exp(-x[1] * x[1]) + x[1] * (
        x[1] + 2
    ) * math.exp(-2 * x[0] * x[0])


def steepest_descent(x: list[float], alpha, tolerance: float):
    n = len(x)
    g0 = g(x)

    fi = grad_g(x)

    del_g = 0

    for i in range(n):
        del_g += fi[i] ** 2

    del_g = math.sqrt(del_g)
    b = alpha / del_g

    while del_g > tolerance:
        for i in range(n):
            x[i] -= b * fi[i]

        fi = grad_g(x)

        del_g = 0

        for i in range(n):
            del_g += fi[i] ** 2

        del_g = math.sqrt(del_g)
        b = alpha / del_g
        g1 = g(x)

        if g1 > g0:
            alpha /= 2
        else:
            g0 = g1


def main():
    tolerance = 0.0000006
    alpha = 0.1
    x = [0.1, -1]

    steepest_descent(x, alpha, tolerance)
    print("Testing steepest descent method:")
    print(
        "The minimum is at x = %f, y = %f for which f(x, y) = %f." % (x[0], x[1], g(x))
    )


if __name__ == "__main__":
    main()
