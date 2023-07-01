from sympy import isprime
for b in range(2, 17):
    print(b, [n for n in range(2, 1001) if isprime(n) and isprime(int('1'*n, base=b))])
