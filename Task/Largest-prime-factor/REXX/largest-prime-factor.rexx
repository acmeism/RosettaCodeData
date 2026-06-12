-- 23 May 2026
Main:
include Setting

say 'LARGEST FACTOR'
say version
say
numeric digits 120
say 'The largest prime factor of...'
call Largest 101
call Largest 720720
call Largest 600851475143
call Largest 600851475144
call Largest 9007199254740991
call Largest 2543821448263974486045199
call Largest 340282366920938463463374607431768211455
call Largest 5465610891074107964192945634873660484494558020574571849718
exit

Largest:
arg xx
n=FactorS(xx)
say xx 'is' Fact.n '('n 'factors,' Format(Elaps('r'),,3)'s)'
return

-- FactorS Elaps
include Math
