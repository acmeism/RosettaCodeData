from itertools import count, islice
import numpy as np
from numpy import sin, cos, pi

# ANGDIV can't be 2, though
ANGDIV = 12
ANG = 2*pi/ANGDIV

def draw_all(sols):
    import matplotlib.pyplot as plt

    def draw_track(ax, s):
        turn, xend, yend = 0, [0], [0]

        for d in s:
            x0, y0 = xend[-1], yend[-1]
            a = turn*ANG
            cs, sn = cos(a), sin(a)
            ang = a + d*pi/2
            cx, cy = x0 + cos(ang), y0 + sin(ang)

            da = np.linspace(ang, ang + d*ANG, 10)
            xs = cx - cos(da)
            ys = cy - sin(da)
            ax.plot(xs, ys, 'green' if d == -1 else 'orange')

            xend.append(xs[-1])
            yend.append(ys[-1])
            turn += d

        ax.plot(xend, yend, 'k.', markersize=1)
        ax.set_aspect(1)

    ls = len(sols)
    if ls == 0: return

    w, h = min((abs(w*2 - h*3) + w*h - ls, w, h)
        for w, h in ((w, (ls + w - 1)//w)
            for w in range(1, ls + 1)))[1:]

    fig, ax = plt.subplots(h, w, squeeze=False)
    for a in ax.ravel(): a.set_axis_off()

    for i, s in enumerate(sols):
        draw_track(ax[i//w, i%w], s)

    plt.show()


def match_up(this, that, equal_lr, seen):
    if not this or not that: return

    n = len(this[0][-1])
    n2 = n*2

    l_lo, l_hi, r_lo, r_hi = 0, 0, 0, 0

    def record(m):
        for _ in range(n2):
            seen[m] = True
            m = (m&1) << (n2 - 1) | (m >> 1)

        if equal_lr:
            m ^= (1<<n2) - 1
            for _ in range(n2):
                seen[m] = True
                m = (m&1) << (n2 - 1) | (m >> 1)

    l_n, r_n = len(this), len(that)
    tol = 1e-3

    while l_lo < l_n:
        while l_hi < l_n and this[l_hi][0] - this[l_lo][0] <= tol:
            l_hi += 1

        while r_lo < r_n and that[r_lo][0] < this[l_lo][0] - tol:
            r_lo += 1

        r_hi = r_lo
        while r_hi < r_n and that[r_hi][0] < this[l_lo][0] + tol:
            r_hi += 1

        for a in this[l_lo:l_hi]:
            m_left = a[-2]<<n
            for b in that[r_lo:r_hi]:
                if (m := m_left | b[-2]) not in seen:
                    if np.abs(a[1] + b[2]) < tol:
                        record(m)
                        record(int(f'{m:b}'[::-1], base=2))
                        yield(a[-1] + b[-1])

        l_lo, r_lo = l_hi, r_hi

def track_combo(left, right):
    n = (left + right)//2
    n1 = left + right - n

    alphas = np.exp(1j*ANG*np.arange(ANGDIV))
    def half_track(m, n):
        turns = tuple(1 - 2*(m>>i & 1) for i in range(n))
        rcnt = np.cumsum(turns)%ANGDIV
        asum = np.sum(alphas[rcnt])
        want = asum/alphas[rcnt[-1]]
        return np.abs(asum), asum, want, m, turns

    res = [[] for _ in range(right + 1)]
    for i in range(1<<n):
        b = i.bit_count()
        if b <= right:
            res[b].append(half_track(i, n))

    for v in res: v.sort()
    if n1 == n:
        return res, res

    res1 = [[] for _ in range(right + 1)]
    for i in range(1<<n1):
        b = i.bit_count()
        if b <= right:
            res1[b].append(half_track(i, n1))

    for v in res: v.sort()
    return res, res1

def railway(n):
    seen = {}

    for l in range(n//2, n + 1):
        r = n - l
        if not l >= r: continue

        if (l - r)%ANGDIV == 0:
            res_l, res_r = track_combo(l, r)

            for i, this in enumerate(res_l):
                if 2*i < r: continue
                that = res_r[r - i]
                for s in match_up(this, that, l == r, seen):
                    yield s

sols = []
for i, s in enumerate(railway(30)):
    # should show 357 solutions for 30 tracks
    print(i + 1, s)
    sols.append(s)

draw_all(sols[:40])
