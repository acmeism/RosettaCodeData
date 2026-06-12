# CORDIC.py by Xing216
from math import pi, sin, cos, floor

angles = [
    0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
    0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
    0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
    0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
    0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
    0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
    0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058
]
kvalues = [
    0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
    0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
    0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
    0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
    0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
    0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888
]
radians = lambda degrees: (degrees * pi) / 180

def Cordic(alpha, n, c_cos, c_sin):
    i, ix, sigma = 0, 0, 0
    kn, x, y, atn, t, theta = 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    pow2 = 1.0
    newsgn = 1 if floor(alpha / (2.0 * pi)) % 2 == 1 else -1
    if alpha < -pi/2.0 or alpha > pi/2.0:
        if alpha < 0:
            Cordic(alpha + pi, n, x, y)
        else:
            Cordic(alpha - pi, n, x, y)
        c_cos = x * newsgn
        c_sin = y * newsgn
        return c_cos, c_sin
    ix = n - 1
    if ix > 23: ix = 23
    kn = kvalues[ix]
    x = 1
    y = 0
    for i in range(n):
        atn = angles[i]
        sigma = 1 if theta < alpha else -1
        theta += sigma * atn
        t = x
        x -= sigma * y * pow2
        y += sigma * t * pow2
        pow2 /= 2.0
    c_cos = x * kn
    c_sin = y * kn
    return c_cos, c_sin

def main():
    i, th = 0, 0
    thr, c_cos, c_sin = 0.0, 0.0, 0.0
    angles = [-9.0, 0.0, 1.5, 6.0]
    print("  x       sin(x)     diff. sine     cos(x)    diff. cosine")
    for th in range(-90,91,15):
        thr = radians(th)
        c_cos, c_sin = Cordic(thr, 24, c_cos, c_sin)
        sin_diff = c_sin - sin(thr)
        cos_diff = c_cos - cos(thr)
        print(f"{th:+03}.0°  {c_sin:+.8f} ({sin_diff:+.8f}) {c_cos:+.8f} ({cos_diff:+.8f})")
    print("\nx(rads)   sin(x)     diff. sine     cos(x)    diff. cosine")
    for i in range(4):
        thr = angles[i]
        c_cos, c_sin = Cordic(thr, 24, c_cos, c_sin)
        sin_diff = c_sin - sin(thr)
        cos_diff = c_cos - cos(thr)
        print(f"{thr:+4.1f}    {c_sin:+.8f} ({c_sin - sin(thr):+.8f}) {c_cos:+.8f} ({c_cos - cos(thr):+.8f})")

if __name__ in "__main__":
    main()
