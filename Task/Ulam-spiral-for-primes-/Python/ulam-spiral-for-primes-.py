# coding=UTF-8
from __future__ import print_function, division
from math import sqrt

def cell(n, x, y, start=1):
    d, y, x = 0, y - n//2, x - (n - 1)//2
    l = 2*max(abs(x), abs(y))
    d = (l*3 + x + y) if y >= x else (l - x - y)
    return (l - 1)**2 + d + start - 1

def show_spiral(n, symbol='# ', start=1, space=None):
    top = start + n*n + 1
    is_prime = [False,False,True] + [True,False]*(top//2)
    for x in range(3, 1 + int(sqrt(top))):
        if not is_prime[x]: continue
        for i in range(x*x, top, x*2):
            is_prime[i] = False

    cell_str = lambda x: f(x) if is_prime[x] else space
    f = lambda _: symbol # how to show prime cells

    if space == None: space = ' '*len(symbol)

    if not len(symbol): # print numbers instead
        max_str = len(str(n*n + start - 1))
        if space == None: space = '.'*max_str + ' '
        f = lambda x: ('%' + str(max_str) + 'd ')%x

    for y in range(n):
        print(''.join(cell_str(v) for v in [cell(n, x, y, start) for x in range(n)]))
    print()

show_spiral(10, symbol=u'♞', space=u'♘') # black are the primes
show_spiral(9, symbol='', space=' - ')
# for filling giant terminals
#show_spiral(1001, symbol='*', start=42)
