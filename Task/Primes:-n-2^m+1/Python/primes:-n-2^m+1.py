 # primesn2m1.py by Xing216
from gmpy2 import is_prime, mpz

print("  n  m  prime")
for n in range(1, 401):
    m = 0
    term = mpz(n)
    while True:
        if is_prime(term + 1):
            print(f"{n:3d}  {m}  {term + 1:5d}")
            break
        m += 1
        term *= 2
}
