/*REXX program demonstrates passing a function as a  name to a function.*/
n=3735928559
funcName='fib'    ;  q= 10;  call someFunk funcName, q;  call tell
funcName='fact'   ;  q=  6;  call someFunk funcName, q;  call tell
funcName='square' ;  q= 13;  call someFunk funcName, q;  call tell
funcName='cube'   ;  q=  3;  call someFunk funcName, q;  call tell
                     q=721;  call someFunk 'reverse',q;  call tell
say copies('─',30)                     /*display a nice separator fence.*/
say 'done as' d2x(n)"."                /*prove that var N still intact. */
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────subroutines─────────────────────────*/
cube:     return n**3
fact:     !=1;                  do j=2 to n;  !=!*j;  end;        return !
reverse:  return 'REVERSE'(n)
someFunk: procedure; arg ?,n; signal value (?); say result 'result'; return
square:   return n**2
tell:     say right(funcName'('q") = ",20) result;                 return

fib:      if n==0 | n==1 then return n;  _=0;  a=0;  b=1
                   do j=2 to n;   _=a+b;   a=b;   b=_;   end;      return _
