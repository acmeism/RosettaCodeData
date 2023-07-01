def isprime(n):
    if n == 2: return True
    if n == 1 or n % 2 == 0: return False
    root1 = int(n**0.5) + 1;
    for k in range(3, root1, 2):
        if n % k == 0: return False
    return True

queue = [k for k in range(1, 10)]
primes = []

while queue:
    n = queue.pop(0)
    if isprime(n):
        primes.append(n)
    queue.extend(n * 10 + k for k in range(n % 10 + 1, 10))

print(primes)
