def factors(x):
    factors = []
    i = 2
    s = int(x ** 0.5)
    while i < s:
        if x % i == 0:
            factors.append(i)
            x = int(x / i)
            s = int(x ** 0.5)
        i += 1
    factors.append(x)
    return factors

print("First 10 Fermat numbers:")
for i in range(10):
    fermat = 2 ** 2 ** i + 1
    print("F{} = {}".format(chr(i + 0x2080) , fermat))

print("\nFactors of first few Fermat numbers:")
for i in range(10):
    fermat = 2 ** 2 ** i + 1
    fac = factors(fermat)
    if len(fac) == 1:
        print("F{} -> IS PRIME".format(chr(i + 0x2080)))
    else:
        print("F{} -> FACTORS: {}".format(chr(i + 0x2080), fac))
