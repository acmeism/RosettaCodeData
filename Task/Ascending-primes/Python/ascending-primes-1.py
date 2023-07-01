from sympy import isprime

def ascending(x=0):
    for y in range(x*10 + (x%10) + 1, x*10 + 10):
        yield from ascending(y)
        yield(y)

print(sorted(x for x in ascending() if isprime(x)))
