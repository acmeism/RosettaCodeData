#!/usr/bin/python3

import math

def Tanh_Sinh(fp, lower, upper, steps, acc):
    h = 0.1
    h0 = (upper - lower) / 2.0
    h1 = (lower + upper) / 2.0
    rr = 0.0
    for k in range(1, steps + 1):
        ro = rr
        n = (1 << k) - 1
        ss = 0.0
        for i in range(-n, n + 1):
            t = i * h
            sh = math.sinh(t)
            ch = math.cosh(t)
            th = math.tanh(sh * math.pi / 2.0)
            dx = (ch * math.pi / 2.0) / (math.cosh(sh * math.pi / 2.0) ** 2.0)
            xi = h1 + h0 * th
            wt = h * dx
            ss += fp(xi) * wt
        rr = h0 * ss
        if abs(rr - ro) < acc:
            break
    return rr

if __name__ == "__main__":
    print(f"{Tanh_Sinh(math.sin, 0.0, 1.0, 5, 1e-8):.8f}")
    print(f"{Tanh_Sinh(math.exp, -3.0, 3.0, 5, 1e-8):.8f}")
