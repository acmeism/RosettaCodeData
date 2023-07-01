limit = 100
sieve = list(limit)
for i = 2 to limit
    for k = i*i to limit step i
        sieve[k] = 1
    next
    if sieve[i] = 0 see "" + i + " " ok
next
