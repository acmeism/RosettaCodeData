# Wieferich-Primzahlen
MAX: int = 5_000

# Berechnet a^n mod m
def pow_mod(a: int, n: int, m: int) -> int:
    assert n >= 0 and m != 0, "pow_mod(a, n, m), n >= 0, m <> 0"
    res: int = 1
    a %= m
    while n > 0:
        if n%2:
            res = (res*a)%m
            n -= 1
        else:
            a = (a*a)%m
            n //= 2
    return res%m

def is_prime(n: int) -> bool:
    for i in range(2, int(n**0.5) + 1):
        if n%i == 0:
            return False
    return True

def is_wieferich(p: int) -> True:
    if is_prime(p) == False:
        return False
    if pow_mod(2, p - 1, p*p) == 1:
        return True
    else:
        return False

if __name__ == '__main__':
    print(f"Wieferich primes less than {MAX}:")
    for i in range(2, MAX + 1):
        if is_wieferich(i):
            print(i)
