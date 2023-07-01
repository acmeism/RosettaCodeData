def harmonic_sum(i, lo, hi, term):
    return sum(term() for i[0] in range(lo, hi + 1))

i = [0]
print(harmonic_sum(i, 1, 100, lambda: 1.0 / i[0]))
