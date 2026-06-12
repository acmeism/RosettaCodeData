from itertools import accumulate, count

d = {}
for q in accumulate(count(1, 2)):
    k = q
    while k > 0 and k not in d:
        if k < 50: d[k] = q
        k //= 10
    if len(d) == 49: break

print(*map(d.get, range(1, 50)))
