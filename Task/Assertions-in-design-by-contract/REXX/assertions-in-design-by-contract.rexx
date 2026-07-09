-- 7 Jul 2026
include Setting

say 'ASSERTIONS IN DESIGN BY CONTRACT'
say version
say
a=2; b=5
say 'a =' a 'and b =' b
call Assert (a>1 & b>1),'Both a and b must be above 1'
say 'Passed!'
call Assert (b/2=a),'Value b must be 2*a'
say 'Falsified!'
exit
-- Assert
include Math
