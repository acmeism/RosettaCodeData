-- 8 Sep 2025
include Setting

say 'ARBITRARY-PRECISION INTEGERS'
say version
say
-- Low precision to obtain needed digits setting
say 'Using the default of 9 digits...'
a=5**(4**(3**2)); d=Xpon(a)+1
say a 'will have' d 'digits'
call Timer 'r'
-- Full precision takes considerable time
say 'Using full precision...'
numeric digits d
a=5**(4**(3**2))
say Length(a) 'digits'
call Timer 'r'
-- And check results
calc=Left(a,20)'...'Right(a,20)
true='62060698786608744707...92256259918212890625'
say 'Calculated' calc
say 'True value' true
if calc = true then
   say 'Passed!'
else
   say 'Failed!'

exit

include Math
