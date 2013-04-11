def perf(n):
    sum = 0
    for i in xrange(1, n):
        if n % i == 0:
            sum += i
    return sum == n
