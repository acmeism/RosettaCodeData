#!/bin/ksh

# Numbers divisible by their digits, but not by the product of their digits

# # Variables:
#
integer MAXN=1000

# # Functions:
#
# # Function _isdivisible(n) - return 1 if:
# #  - is divisible by individual digits, and
# #  - not divisible by product of digits
#
function _isdivisible {
  typeset _n ; integer _n=$1
  typeset _i _digit _product ; integer _i _digit _product=1

  for ((_i=0; _i<${#_n}; _i++)); do
    _digit=${_n:_i:1}
    (( ! _digit )) || (( _n % _digit )) && return 0
    (( _product*=_digit ))
  done
  return $(( _n % _product ))
}

 ######
# main #
 ######

for ((i=10; i<MAXN; i++)); do
  (( ! i % 10 )) || _isdivisible ${i} || printf "%d " ${i}
done
