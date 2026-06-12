#!/usr/bin/python3

N = 6000
p = [False] * N  #inicializamos la lista

for i in range(2, round(pow(N,0.5))):
    if not p[i]:
        for j in range(i*2, N, i):
            p[j] = True


for i in range(3, N):
    if (p[i-1] or p[i+3] or p[i+5]):
        continue
    else:
        print(i, ': ', i-1,  ' ', i+3,  ' ', i+5)
