def leonardo(l0, l1, inc, amount):
    terms = [l0, l1]
    while len(terms) < amount:
        new = terms[-1] + terms[-2]
        new += inc
        terms.append(new)
    return terms

print("First 25 Leonardo numbers:")
print(" ".join(map(str, leonardo(1, 1, 1, 25))))

print("Leonardo numbers with Fibonacci parameters:")
print(" ".join(map(str, leonardo(0, 1, 0, 25))))
