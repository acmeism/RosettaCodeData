import math

vector = tuple[float, float, float]
matrix = tuple[vector, vector, vector]

def norm(v: vector):
    return math.sqrt(
        v[0] ** 2
        + v[1] ** 2
        + v[2] ** 2
    )

def normalize(v: vector):
    length = norm(v)
    return [
        v[0] / length,
        v[1] / length,
        v[2] / length
    ]

def dot_product(v1: vector, v2: vector):
    return (
        v1[0] * v2[0]
        + v1[1] * v2[1]
        + v1[2] * v2[2]
    )

def cross_product(v1: vector, v2: vector):
    return [
        v1[1] * v2[2] - v1[2] * v2[1],
        v1[2] * v2[0] - v1[0] * v2[2],
        v1[0] * v2[1] - v1[1] * v2[0]
    ]

def get_angle(v1: vector, v2: vector):
    return math.acos(dot_product(v1, v2) / (norm(v1) * norm(v2)))

def matrix_multiply(m: matrix, v: vector):
    return [
        dot_product(m[0], v),
        dot_product(m[1], v),
        dot_product(m[2], v)
    ]

def a_rotate(p: vector, v: vector, a: float):
    ca = math.cos(a)
    sa = math.sin(a)
    t = 1 - ca
    x=v[0]
    y=v[1]
    z=v[2]

    r = [
        [ca + x*x*t, x*y*t - z*sa, x*z*t + y*sa],
        [x*y*t + z*sa, ca + y*y*t, y*z*t - x*sa],
        [z*x*t - y*sa, z*y*t + x*sa, ca + z*z*t]
    ]

    return matrix_multiply(r, p)

def main():
    v1 = [5, -6, 4]
    v2 = [8, 5, -30]

    a = get_angle(v1, v2)
    cp = cross_product(v1, v2)
    ncp = normalize(cp)
    np = a_rotate(v1, ncp, a)

    print(np)

if __name__ == '__main__':
    main()
