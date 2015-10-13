def nextperm(a):
    n = len(a)
    i = n - 1
    while i > 0 and a[i - 1] > a[i]:
        i -= 1
    j = i
    k = n - 1
    while j < k:
        a[j], a[k] = a[k], a[j]
        j += 1
        k -= 1
    if i == 0:
        return False
    else:
        j = i
        while a[j] < a[i - 1]:
            j += 1
        a[i - 1], a[j] = a[j], a[i - 1]
        return True

def perm3(n):
    if type(n) is int:
        if n < 1:
            return []
        a = list(range(n))
    else:
        a = sorted(n)
    u = [tuple(a)]
    while nextperm(a):
        u.append(tuple(a))
    return u

for p in perm3(3): print(p)
(0, 1, 2)
(0, 2, 1)
(1, 0, 2)
(1, 2, 0)
(2, 0, 1)
(2, 1, 0)
