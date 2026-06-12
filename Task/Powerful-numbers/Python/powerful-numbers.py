from primesieve import primes # any prime generation routine will do; don't need large primes
import math

def primepowers(k, upper_bound):
    ub = int(math.pow(upper_bound, 1/k) + .5)
    res = [(1,)]

    for p in primes(ub):
        a = [p**k]
        u = upper_bound // a[-1]
        while u >= p:
            a.append(a[-1]*p)
            u //= p
        res.append(tuple(a))

    return res

def kpowerful(k, upper_bound, count_only=True):
    ps = primepowers(k, upper_bound)

    def accu(i, ub):
        c = 0 if count_only else []
        for p in ps[i]:
            u = ub//p
            if not u: break

            c += 1 if count_only else [p]

            for j in range(i + 1, len(ps)):
                if u < ps[j][0]:
                    break
                c += accu(j, u) if count_only else [p*x for x in accu(j, u)]
        return c

    res = accu(0, upper_bound)
    return res if count_only else sorted(res)

for k in range(2, 11):
    res = kpowerful(k, 10**k, count_only=False)
    print(f'{len(res)} {k}-powerfuls up to 10^{k}:',
        ' '.join(str(x) for x in res[:5]),
        '...',
        ' '.join(str(x) for x in res[-5:])
        )

for k in range(2, 11):
    res = [kpowerful(k, 10**n) for n in range(k+10)]
    print(f'{k}-powerful up to 10^{k+10}:',
        ' '.join(str(x) for x in res))
