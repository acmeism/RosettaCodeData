from math import isqrt

def juggler(k, countdig=True, maxiters=1000):
    m, maxj, maxjpos = k, k, 0
    for i in range(1, maxiters):
        m = isqrt(m) if m % 2 == 0 else isqrt(m * m * m)
        if m >= maxj:
            maxj, maxjpos  = m, i
        if m == 1:
            print(f"{k: 9}{i: 6,}{maxjpos: 6}{len(str(maxj)) if countdig else maxj: 20,}{' digits' if countdig else ''}")
            return i

    print("ERROR: Juggler series starting with $k did not converge in $maxiters iterations")


print("       n    l(n)  i(n)       h(n) or d(n)\n-------------------------------------------")
for k in range(20, 40):
    juggler(k, False)

for k in [113, 173, 193, 2183, 11229, 15065, 15845, 30817, 48443, 275485, 1267909]:
    juggler(k)
