/ The base is 10^9, the largest number that can be multiplied with
/ itself w/o overflow.
base: */9#10

/ multiply x*y; either y or x must be less than the base.
mul: {
    a: x*y

    / (-base)!a is the carry; base!a (residues) are the new digits
    a: ((-base)!a, 0) + (0, base!a)

    / Propagate any remaining carries from the addition
    a: (c, 0) + 0, a-base*c: ~a<base
    {0=*x} {1_x}/ a}

/ accumulate x!
fac: {mul\[,1;1+!x]}

/ digital length
digits: {(#$*x) + 9*-1 + #x}

/ zero count (string)
zcs: +/"0"=$:

/ zero count (mod 1000)
zc999: zcs' !1000 / only valid from 100 ... 999
zc999[0]: 3
zc999[1+!9]: 2
zc999[10+!90]: 1
zc999[10*1+!9]: 2 / Correct for multiples of 10

/ general zero count; only stringify the head, use (mod 1000) for the rest
zc: {zcs[*x] +/ zc999[,/+(3 # 1000)\1_x]}

/ ratio of zeros to length
zrat: {+/({zc[x] % digits[x]}' fac[x]) % x}

/ show results
z: {`0: "distribution of zeros from 1! to ", ($x), "! = ", $zrat[x]}' 100 1000 10000
