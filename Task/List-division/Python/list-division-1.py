def listdiv(l, n):
    "Divide a list into n (approximately) equal parts."
    if n > len(l):
        raise ValueError("n is too large.")
    step, r = divmod(len(l), n)
    out = []
    i = 0
    for part in range(1, n+1):
        nextchunksize = step + 1 if part <= r else step
        out.append(l[i: i+nextchunksize])
        i += nextchunksize
    return out

print(listdiv([94, 94, 13, 77, 35, 10, 51, 27, 60],6))
print(listdiv([19, 46, 43, 17, 94],1))
print(listdiv([93, 88, 40, 88, 30, 68, 84, 25],3))
print(listdiv([88, 94, 10, 27, 54, 14],3))
print(listdiv([31, 19, 63, 57, 57, 74, 50, 14, 38],4))
# Expected: [[31, 19, 63], [57, 57], [74, 50], [14, 38]]
print(listdiv([72, 57, 89, 55, 36, 84, 10, 95, 99, 35],7))
# Expected: [[72, 57], [89, 55], [36, 84], [10], [95], [99], [35]]

# Check for edge-cases:
checks = [[23, 49, 57], [1], []]
nums   = [10, 2, 2]
for c,n in zip(checks, nums):
    try:
        if n < 0: raise ValueError("n must be a positive integer.")
        print(listdiv(c, n))
    except Exception as e:
        print(type(e).__name__+":",e)
print('-'*20)

import random
for _ in range(10):
    l = random.choices(range(10, 100), k=random.randint(0, 10))
    n = random.randint(-1, 10)
    print(f"listdiv({l},{n}) = ")
    try:
        if n < 0: raise ValueError("n must be a positive integer.")
        print(" ",listdiv(l, n))
    except Exception as e:
        print(type(e).__name__+":",e)
