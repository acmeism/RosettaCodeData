primelist = [2, 3]
def is_prime(n):
    if n in primelist: return True
    if n < primelist[-1]: return False

    for y in primes():
        if not n % y: return False
        if n < y * y: return True

def primes():
    for n in primelist: yield n

    n = primelist[-1]
    while True:
        n += 2
        for x in primelist:
            if not n % x: break
            if x * x > n:
                primelist.append(n)
                yield n
                break
