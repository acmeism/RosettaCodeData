from itertools import islice


def hailstone(n):
    yield n
    while n > 1:
        n = 3 * n + 1 if n & 1 else n // 2
        yield n


if __name__ == '__main__':
    h = hailstone(27)
    assert list(islice(h, 4)) == [27, 82, 41, 124]
    for _ in range(112 - 4 * 2):
        next(h)
    assert list(islice(h, 4)) == [8, 4, 2, 1]
    max_length, n = max((sum(1 for _ in hailstone(i)), i)
                        for i in range(1, 100_000))
    print(f"Maximum length {max_length} was found for hailstone({n}) "
          f"for numbers <100,000")
