#!/usr/bin/env python3

import math

def thieleInterpolator(x, y):
    ρ = [[yi]*(len(y)-i) for i, yi in enumerate(y)]
    for i in range(len(ρ)-1):
        ρ[i][1] = (x[i] - x[i+1]) / (ρ[i][0] - ρ[i+1][0])
    for i in range(2, len(ρ)):
        for j in range(len(ρ)-i):
            ρ[j][i] = (x[j]-x[j+i]) / (ρ[j][i-1]-ρ[j+1][i-1]) + ρ[j+1][i-2]
    ρ0 = ρ[0]
    def t(xin):
        a = 0
        for i in range(len(ρ0)-1, 1, -1):
            a = (xin - x[i-1]) / (ρ0[i] - ρ0[i-2] + a)
        return y[0] + (xin-x[0]) / (ρ0[1]+a)
    return t

# task 1: build 32 row trig table
xVal = [i*.05 for i in range(32)]
tSin = [math.sin(x) for x in xVal]
tCos = [math.cos(x) for x in xVal]
tTan = [math.tan(x) for x in xVal]
# task 2: define inverses
iSin = thieleInterpolator(tSin, xVal)
iCos = thieleInterpolator(tCos, xVal)
iTan = thieleInterpolator(tTan, xVal)
# task 3: demonstrate identities
print('{:16.14f}'.format(6*iSin(.5)))
print('{:16.14f}'.format(3*iCos(.5)))
print('{:16.14f}'.format(4*iTan(1)))
