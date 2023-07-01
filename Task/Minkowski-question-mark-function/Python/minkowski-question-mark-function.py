import math

MAXITER = 151


def minkowski(x):
    if x > 1 or x < 0:
        return math.floor(x) + minkowski(x - math.floor(x))

    p = int(x)
    q = 1
    r = p + 1
    s = 1
    d = 1.0
    y = float(p)

    while True:
        d /= 2
        if y + d == y:
            break

        m = p + r
        if m < 0 or p < 0:
            break

        n = q + s
        if n < 0:
            break

        if x < m / n:
            r = m
            s = n
        else:
            y += d
            p = m
            q = n

    return y + d


def minkowski_inv(x):
    if x > 1 or x < 0:
        return math.floor(x) + minkowski_inv(x - math.floor(x))

    if x == 1 or x == 0:
        return x

    cont_frac = [0]
    current = 0
    count = 1
    i = 0

    while True:
        x *= 2

        if current == 0:
            if x < 1:
                count += 1
            else:
                cont_frac.append(0)
                cont_frac[i] = count

                i += 1
                count = 1
                current = 1
                x -= 1
        else:
            if x > 1:
                count += 1
                x -= 1
            else:
                cont_frac.append(0)
                cont_frac[i] = count

                i += 1
                count = 1
                current = 0

        if x == math.floor(x):
            cont_frac[i] = count
            break

        if i == MAXITER:
            break

    ret = 1.0 / cont_frac[i]
    for j in range(i - 1, -1, -1):
        ret = cont_frac[j] + 1.0 / ret

    return 1.0 / ret


if __name__ == "__main__":
    print(
        "{:19.16f} {:19.16f}".format(
            minkowski(0.5 * (1 + math.sqrt(5))),
            5.0 / 3.0,
        )
    )

    print(
        "{:19.16f} {:19.16f}".format(
            minkowski_inv(-5.0 / 9.0),
            (math.sqrt(13) - 7) / 6,
        )
    )

    print(
        "{:19.16f} {:19.16f}".format(
            minkowski(minkowski_inv(0.718281828)),
            minkowski_inv(minkowski(0.1213141516171819)),
        )
    )
