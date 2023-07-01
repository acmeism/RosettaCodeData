def zinit():
    zc = [0] * 999
    for x in range(1, 10):
        zc[x - 1] = 2        # 00x
        zc[10 * x - 1] = 2   # 0x0
        zc[100 * x - 1] = 2  # x00
        for y in range(10, 100, 10):
            zc[y + x - 1] = 1           # 0yx
            zc[10 * y + x - 1] = 1      # y0x
            zc[10 * (y + x) - 1] = 1    # yx0

    return zc

def meanfactorialdigits():
    zc = zinit()
    rfs = [1]
    total, trail, first = 0.0, 1, 0
    for f in range(2, 50000):
        carry, d999, zeroes = 0, 0, (trail - 1) * 3
        j, l = trail, len(rfs)
        while j <= l or carry != 0:
            if j <= l:
                carry = rfs[j-1] * f + carry

            d999 = carry % 1000
            if j <= l:
                rfs[j-1] = d999
            else:
                rfs.append(d999)

            zeroes += 3 if d999 == 0 else zc[d999-1]
            carry //= 1000
            j += 1

        while rfs[trail-1] == 0:
            trail += 1

        # d999 is a quick correction for length and zeros
        d999 = rfs[-1]
        d999 = 0 if d999 >= 100 else 2 if d999 < 10 else 1

        zeroes -= d999
        digits = len(rfs) * 3 - d999
        total += zeroes / digits
        ratio = total / f
        if f in [100, 1000, 10000]:
            print("The mean proportion of zero digits in factorials to {} is {}".format(f, ratio))

        if ratio >= 0.16:
            first = 0
        elif first == 0:
            first = f

    print("The mean proportion dips permanently below 0.16 at {}.".format(first))



import time
TIME0 = time.perf_counter()
meanfactorialdigits()
print("\nTotal time:", time.perf_counter() - TIME0, "seconds.")
