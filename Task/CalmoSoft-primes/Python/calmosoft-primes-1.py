from sympy import isprime, primerange

pri = list(primerange(1, 100))

lcal = sorted([pri[i:j] for j in range(len(pri), 0, -1)
          for i in range(len(pri)) if j > i and isprime(sum(pri[i:j]))], key=len)[-1]

print(f'Longest Calmo prime seq (length {len(lcal)}) of primes less than 100 is:\n{lcal}')
