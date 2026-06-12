#!/usr/bin/python

maxArea = 1000
halfMaxArea = 500
T = []                           #table of half areas
for i in range(halfMaxArea):
    T.append(True)               #assume all are O'kalloran numbers

for l in range(1,maxArea):
    for w in range(1, halfMaxArea):
        for h in range(1, halfMaxArea):
            suma = l*w + l*h + w*h
            if suma < halfMaxArea:
                T[suma] = False  #not an O'kalloran number

print("All known O'Halloran numbers:")
for l in range(3,halfMaxArea):
    if T[l]:
        print(l*2, end=" ");
