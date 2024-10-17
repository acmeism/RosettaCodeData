println([n for n = 1:5000 if sum(d^d for d in digits(n)) == n])
