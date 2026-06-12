#!/usr/bin/python3

# calculate the decimal digits of e and count how many times each
# digit occurs - based On the B code On the Wikipedia page:
# https://en.wikipedia.org/wiki/B_(programming_language)

dcount = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0]

MaxIDx = 2000

v = [1] * MaxIDx

for col in range(2 * MaxIDx + 1):
    a = MaxIDx + 1
    c = 0

    for i in range(MaxIDx):
        c += v[i] * 10
        v[i] = c % a
        c //= a
        a -= 1

    dcount[c] += 1

output = ' '.join(str(count) for count in dcount)
print(output)
