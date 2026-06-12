def decompose(n, b):
    if n < b:
        return n
    decomp = []
    e = 0
    while n != 0:
        n, r = divmod(n, b)
        if r > 0:
            decomp.append([r, decompose(e, b)])
        e += 1

    return decomp


def evaluate(d, b):
    if type(d) is int:
        return d
    return sum(j * b ** evaluate(k, b) for j, k in d)


def goodstein(n, maxlen=10):
    seq = []
    b = 2
    while len(seq) < maxlen:
        seq.append(n)
        if n == 0:
            break
        d = decompose(n, b)
        b += 1
        n = evaluate(d, b) - 1

    return seq


def A266201(n):
    """Get the Nth term of Goodstein(n) sequence counting from 0, see https://oeis.org/A266201"""
    return goodstein(n, n + 1)[-1]


if __name__ == "__main__":

    print("Goodstein(n) sequence (first 10) for values of n from 0 through 7:")
    for i in range(8):
        print(f"Goodstein of {i}: {goodstein(i)}")

    print(
        "\nThe Nth term of Goodstein(N) sequence counting from 0, for values of N from 0 through 16:"
    )
    for i in range(17):
        print(f"Term {i} of Goodstein({i}): {A266201(i)}")
