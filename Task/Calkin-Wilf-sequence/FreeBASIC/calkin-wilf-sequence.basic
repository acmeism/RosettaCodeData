#include "gcd.bas"

type rational
    num as integer
    den as integer
end type

dim shared as rational ONE, TWO
ONE.num = 1 : ONE.den = 1
TWO.num = 2 : TWO.den = 1

function simplify( byval a as rational ) as rational
   dim as uinteger g = gcd( a.num, a.den )
   a.num /= g : a.den /= g
   if a.den < 0 then
       a.den = -a.den
       a.num = -a.num
   end if
   return a
end function

operator + ( a as rational, b as rational ) as rational
    dim as rational ret
    ret.num = a.num * b.den + b.num*a.den
    ret.den = a.den * b.den
    return simplify(ret)
end operator

operator - ( a as rational, b as rational ) as rational
    dim as rational ret
    ret.num = a.num * b.den - b.num*a.den
    ret.den = a.den * b.den
    return simplify(ret)
end operator

operator * ( a as rational, b as rational ) as rational
    dim as rational ret
    ret.num = a.num * b.num
    ret.den = a.den * b.den
    return simplify(ret)
end operator

operator / ( a as rational, b as rational ) as rational
    dim as rational ret
    ret.num = a.num * b.den
    ret.den = a.den * b.num
    return simplify(ret)
end operator

function floor( a as rational ) as rational
    dim as rational ret
    ret.den = 1
    ret.num = a.num \ a.den
    return ret
end function

function cw_nextterm( q as rational ) as rational
    dim as rational ret = (TWO*floor(q))
    ret = ret + ONE : ret = ret - q
    return ONE / ret
end function

function frac_to_int( byval a as rational ) as uinteger
    redim as uinteger cfrac(-1)
    dim as integer  lt = -1, ones = 1, ret = 0
    do
        lt += 1
        redim preserve as uinteger cfrac(0 to lt)
        cfrac(lt) = floor(a).num
        a = a - floor(a) : a = ONE / a
    loop until a.num = 0 or a.den = 0
    if lt mod 2 = 1 and cfrac(lt) = 1 then
        lt -= 1
        cfrac(lt)+=1
        redim preserve as uinteger cfrac(0 to lt)
    end if
    if lt mod 2 = 1 and cfrac(lt) > 1 then
        cfrac(lt) -= 1
        lt += 1
        redim preserve as uinteger cfrac(0 to lt)
        cfrac(lt) = 1
    end if
    for i as integer = lt to 0 step -1
        for j as integer = 1 to cfrac(i)
            ret *= 2
            if ones = 1 then  ret += 1
        next j
        ones = 1 - ones
    next i
    return ret
end function

function disp_rational( a as rational ) as string
    if a.den = 1 or a.num= 0 then return str(a.num)
    return str(a.num)+"/"+str(a.den)
end function

dim as rational q
q.num = 1
q.den = 1
for i as integer = 1 to 20
    print i, disp_rational(q)
    q = cw_nextterm(q)
next i

q.num = 83116
q.den = 51639
print disp_rational(q)+" is the "+str(frac_to_int(q))+"th term."
