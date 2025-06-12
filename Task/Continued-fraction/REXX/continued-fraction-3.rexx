-- 8 May 2025
include Settings
numeric digits 30
say 'CONTINUED FRACTION'
say version
say
say 'SqRt(2) =' QcontFrac(1,2,1,1,10)
say 'Must be =' SqRt(2)/1
say 'e       =' QcontFrac(2,'n',1,'n-1',10)
say 'Must be =' E()/1
say 'Pi      =' QcontFrac(3,6,1,'(2*n-1)**2',10)
say 'Must be =' Pi()/1
say
say 'Pi      =' 4/QcontFrac(1,'2*n+1',1,'n**2',10)
say 'Must be =' Pi()/1
say 'Ln(2)   =' QcontFrac(0,'6*n-3',2,'-((n-1)**2)',10)
say 'Must be =' Ln(2)/1
say 'e^2     =' QcontFrac(7,'2*n+3',2,1,10)
say 'Must be =' E()*E()/1
say 'Phi     =' QcontFrac(1,1,1,1,10)
say 'Must be =' Golden()/1
say '2^(1/3) =' QcontFrac(1,'2+Odd(n)*(3*n-2)',1,'n+((n+1)%2-1)',10)
say 'Must be =' CbRt(2)/1
say 'Tan(1)  =' QcontFrac(0,'2*n-1',1,-1,10)
say 'Must be =' Tan(1)
exit

include Rational
include Functions
include Constants
include Abend
