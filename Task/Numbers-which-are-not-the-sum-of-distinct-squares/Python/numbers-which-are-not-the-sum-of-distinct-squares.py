import math


def soms(n: int, f: list[int]):
    if n <= 0:
        return False

    if n in f:
        return True

    sumation = sum(f)

    if n > sumation:
        return False

    if n == sumation:
        return True

    rf = f.copy()
    i, j = 0, len(rf) - 1

    while i < j:
        rf[i], rf[j] = rf[j], rf[i]
        i += 1
        j -= 1

    rf = rf[1:]
    return soms(n - f[len(f) - 1], rf) or soms(n, rf)


def main():
    s = []
    a = []

    sf = "\nStopped checking after finding %d sequential non-gaps after the final gap of %d\n"

    i, g = 1, 1

    while g >= (i >> 1):
        r = int(math.sqrt(i))

        if r * r == i:
            s.append(i)

        if not soms(i, s):
            g = i
            a.append(g)

        i += 1

    print("Numbers which are not the sum of distinct squares:")
    print(a)
    print(sf % (i - g, g), end="")
    print("Found %d in total" % len(a))


if __name__ == "__main__":
    main()
