#!/usr/bin/python

from sympy import primefactors

res = [1]
count = 1
i = 2
lim1 = 100
lim2 = 1000
max = 1e7

while count < max:
    cubeFree = False
    factors = primefactors(i)
    if len(factors) < 3:
        cubeFree = True
    else:
        cubeFree = True
        for j in range(2, len(factors)):
            if factors[j-2] == factors[j-1] and factors[j-1] == factors[j]:
                cubeFree = False
                break
    if cubeFree:
        if count < lim1:
            res.append(factors[-1])
        count += 1
        if count == lim1:
            print("First {} terms of a[n]:".format(lim1))
            for k in range(0, len(res), 10):
                print(" ".join(map(str, res[k:k+10])))
            print("")
        elif count == lim2:
            print("The {} term of a[n] is {}".format(count, factors[-1]))
            lim2 *= 10
    i += 1
