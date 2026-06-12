-- 23 Aug 2025
include Setting

say 'COPRIMES'
say version
say
numeric digits 10
call ShowResults
say Format(Time('e'),,3) 'seconds'
exit

ShowResults:
say 'Coprimes (1 = Yes, 0 = No)'
say '21,15' Coprime(21,15)
say '17,23' Coprime(17,23)
say '36,12' Coprime(36,12)
say '18,29' Coprime(18,29)
say '60,15' Coprime(60,15)
return

include Math
