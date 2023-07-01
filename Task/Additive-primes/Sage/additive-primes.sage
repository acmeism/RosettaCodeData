limit = 500
additivePrimes = list(filter(lambda x: x > 0,
                             list(map(lambda x: int(x) if sum([int(digit) for digit in x]) in Primes() else 0,
                                      list(map(str,list(primes(1,limit))))))))
print(f"{additivePrimes}\nFound {len(additivePrimes)} additive primes less than {limit}")
