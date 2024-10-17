/* REXX */
Call time 'R'
cnt.=0
Do x=1 to 20000
  sumpd=Sigma(x)-x
  Select
    When x<sumpd Then do
       cnt.abundant =cnt.abundant +1
       end
    When x=sumpd Then do
       cnt.perfect  =cnt.perfect  +1
       end
    Otherwise         do
       cnt.deficient=cnt.deficient+1
       end
    End
    end

Say 'In the range 1 - 20000'
Say format(cnt.abundant ,5) 'numbers are abundant  '
Say format(cnt.perfect  ,5) 'numbers are perfect   '
Say format(cnt.deficient,5) 'numbers are deficient '
Say time('E') 'seconds elapsed'
Exit

include Numbers
include Functions
