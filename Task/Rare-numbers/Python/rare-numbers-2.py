# rare.py
# by xing216

import time as t
from functools import cache

@cache
def isSquare(n: int) ->bool:
    if n < 0:
        return False
    if n == 0:
        return True
    while n&3 == 0:
        n=n>>2
    if n&7 != 1:
        return False
    if n==1:
        return True
    c = n%10
    if c in {3, 7}:
        return False
    if n % 7 in {3, 5, 6}:
        return False
    if n % 9 in {2,3,5,6,8}:
        return False
    if n % 13 in {2,5,6,7,8,11}:
        return False
    if c == 5:
        if (n//10)%10 != 2:
            return False
        if (n//100)%10 not in {0,2,6}:
            return False
        if (n//100)%10 == 6:
            if (n//1000)%10 not in {0,5}:
                return False
    else:
        if (n//10)%4 != 0:
            return False
    s = (len(str(n))-1) // 2
    x = (10**s) * 4
    A = {x, n}
    while x * x != n:
        x = (x + (n // x)) >> 1
        if x in A:
            return False
        A.add(x)
    return True

@cache
def main() -> None:
    r = 1
    start = t.time()
    while True:
        strr = str(r)
        if int(strr[0]) % 2 != 0:
            r += int('1' + (len(strr)-1)*'0' )
        r1 = int(strr[::-1])
        x = r + r1
        y = r - r1
        if isSquare(x) and isSquare(y) and r != r1:
            print(f'success:  {r} ~{t.time()-start}s')
        r+=1
if __name__ == '__main__':
    main()
