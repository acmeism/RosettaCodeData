from itertools import groupby

def magic_numbers(base):
    hist = []
    n = l = i = 0
    while True:
        l += 1
        hist.extend((n + digit, l) for digit in range(-n % l, base, l))
        i += 1
        if i == len(hist):
            return hist
        n, l = hist[i]
        n *= base

mn = magic_numbers(10)
print("found", len(mn), "magic numbers")
print("the largest one is", mn[-1][0])

print("count by number of digits:")
print(*(f"{l}:{sum(1 for _ in g)}" for l, g in groupby(l for _, l in mn)))

print(end="minimally pandigital in 1..9: ")
print(*(m for m, l in mn if l == 9 == len(set(str(m)) - {"0"})))
print(end="minimally pandigital in 0..9: ")
print(*(m for m, l in mn if l == 10 == len(set(str(m)))))
