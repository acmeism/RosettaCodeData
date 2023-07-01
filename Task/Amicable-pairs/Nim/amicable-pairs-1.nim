from math import sqrt

const N = 524_000_000.int32

proc sumProperDivisors(someNum: int32, chk4less: bool): int32 =
    result = 1
    let maxPD = sqrt(someNum.float).int32
    let offset = someNum mod 2
    for divNum in countup(2 + offset, maxPD, 1 + offset):
        if someNum mod divNum == 0:
            result += divNum + someNum div divNum
            if chk4less and result >= someNum:
                return 0

for n in countdown(N, 2):
    let m = sumProperDivisors(n, true)
    if m != 0 and n == sumProperDivisors(m, false):
        echo $n, " ", $m
