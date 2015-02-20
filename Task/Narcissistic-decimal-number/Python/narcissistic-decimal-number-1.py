from __future__ import print_function
from itertools import count, islice

def narcissists():
    for digits in count(0):
        digitpowers = [i**digits for i in range(10)]
        for n in range(int(10**(digits-1)), 10**digits):
            div, digitpsum = n, 0
            while div:
                div, mod = divmod(div, 10)
                digitpsum += digitpowers[mod]
            if n == digitpsum:
                yield n

for i, n in enumerate(islice(narcissists(), 25), 1):
    print(n, end=' ')
    if i % 5 == 0: print()
print()
