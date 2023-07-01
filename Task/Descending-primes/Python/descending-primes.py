from sympy import isprime

def descending(xs=range(10)):
    for x in xs:
        yield x
        yield from descending(x*10 + d for d in range(x%10))

for i, p in enumerate(sorted(filter(isprime, descending()))):
    print(f'{p:9d}', end=' ' if (1 + i)%8 else '\n')

print()
