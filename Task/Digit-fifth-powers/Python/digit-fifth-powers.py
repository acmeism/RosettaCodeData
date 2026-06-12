from time import time

# conventional
st = time()
print(sum([n for n in range(2, 6*9**5) if sum(int(i)**5 for i in str(n)) == n]), "  ", (time() - st) * 1000, "ms")

# faster
st = time()
nums = list(range(10))
nu = list(range(((6 * 9**5) // 100000) + 1))
numbers = []
p5 = []
for i in nums: p5.append(i**5)
for i in nu:
    im = i * 100000
    ip = p5[i]
    for j in nums:
        jm = im + 10000 * j
        jp = ip + p5[j]
        for k in nums:
            km = jm + 1000 * k
            kp = jp + p5[k]
            for l in nums:
                lm = km + 100 * l
                lp = kp + p5[l]
                for m in nums:
                    mm = lm + 10 * m
                    mp = lp + p5[m]
                    for n in nums:
                        nm = mm + n
                        np = mp + p5[n]
                        if np == nm:
                            if nm > 1: numbers.append(nm)
print(sum(numbers), "  ", (time() - st) * 1000, "ms", end = "")
