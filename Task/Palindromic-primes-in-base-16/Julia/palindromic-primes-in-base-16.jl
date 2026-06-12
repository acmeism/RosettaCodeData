using Primes

ispal(n, base) = begin dig = digits(n, base=base); dig == reverse(dig) end

palprimes(N, base=16) = [string(i, base=16) for i in primes(N) if ispal(i, base)]

foreach(s -> print(s, " "), palprimes(500, 16)) # 2 3 5 7 b d 11 101 151 161 191 1b1 1c1
