from sympy import isprime

def ispseudo(n, base):
    return not isprime(n) and pow(base, n - 1, n) == 1

for b in range(1, 21):
    pseudos = [n for n in range(1, 50001) if ispseudo(n, b)]
    print(f"Base {str(b).rjust(2)} up to 50000: {str(len(pseudos)).rjust(5)}  First 20: {pseudos[:20]}")
