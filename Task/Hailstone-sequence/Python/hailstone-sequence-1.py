def hailstone(n):
    seq = [n]
    while n > 1:
        n = 3 * n + 1 if n & 1 else n // 2
        seq.append(n)
    return seq


if __name__ == '__main__':
    h = hailstone(27)
    assert (len(h) == 112
            and h[:4] == [27, 82, 41, 124]
            and h[-4:] == [8, 4, 2, 1])
    max_length, n = max((len(hailstone(i)), i) for i in range(1, 100_000))
    print(f"Maximum length {max_length} was found for hailstone({n}) "
          f"for numbers <100,000")
