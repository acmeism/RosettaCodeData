def pop_kernighan(n):
    i = 0
    while n:
        i, n = i + 1, n & (n - 1)
    return i
