n = 20
def z(n):
    if n == 0 : return [0]
    fib = [2,1]
    while fib[0] < n: fib[0:0] = [sum(fib[:2])]
    dig = []
    for f in fib:
        if f <= n:
            dig, n = dig + [1], n - f
        else:
            dig += [0]
    return dig if dig[0] else dig[1:]

for i in range(n + 1):
    print('%3i: %8s' % (i, ''.join(str(d) for d in z(i))))
