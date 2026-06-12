import math
def listdiv(l, n):
    "Divide a list into n (approximately) equal parts."
    divisible = False
    if (len(l) / n).is_integer():
        step = len(l) // n
        divisible = True
    else:
        step = len(l) // n
    if n > len(l):
        raise ValueError("n is too large.")
    out = []
    i = 0
    if divisible:
        while i < len(l):
            out.append(l[i:i+step])
            i += step
        return out
    else:
        my_l = len(l)
        my_n = n
        while True:
            out.insert(0, l[-(my_l//n):])
            l = l[:-(my_l//n)]
            my_n -= 1
            if (len(l) / my_n).is_integer():
                break
        l = listdiv(l, my_n)
        out = l + out

    return out

print(listdiv([94, 94, 13, 77, 35, 10, 51, 27, 60],6))
print(listdiv([19, 46, 43, 17, 94],1))
print(listdiv([93, 88, 40, 88, 30, 68, 84, 25],3))
print(listdiv([88, 94, 10, 27, 54, 14],3))
print(listdiv([31, 19, 63, 57, 57, 74, 50, 14, 38],4))
# Expected: [[31, 19, 63], [57, 57], [74, 50], [14, 38]]
print(listdiv([72, 57, 89, 55, 36, 84, 10, 95, 99, 35],7))
# Expected: [[72, 57], [89, 55], [36, 84], [10], [95], [99], [35]]

checks = [[23, 49, 57], [1], []]
nums   = [10, 2, 2]
for c,n in zip(checks, nums):
    try:
        print(listdiv(c, n))
    except Exception as e:
        print(type(e).__name__+":",e)
