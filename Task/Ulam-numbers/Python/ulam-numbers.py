import time

def ulam(n):
    if n <= 2:
        return n
    mx = 1352000
    lst = [1, 2] + [0] * mx
    sums = [0] * (mx * 2 + 1)
    sums[3] = 1
    size = 2
    while size < n:
        query = lst[size-1] + 1
        while True:
            if sums[query] == 1:
                for i in range(size):
                    sum = query + lst[i]
                    t = sums[sum] + 1
                    if t <= 2:
                        sums[sum] = t
                lst[size], size = query, size + 1
                break
            query += 1
    return query

t0 = time.time()
for p in range(5):
    n = 10**p
    print(f"The {n}{'th' if n!=1 else 'st'} Ulam number is {ulam(n)}")

print("\nElapsed time:", time.time() - t0)
