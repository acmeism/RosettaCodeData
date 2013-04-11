/*REXX pgm counts frequency of various subroutine/function invocations. */
?.=0                                   /*initialize all funky counters. */
             do j=1 to 10
             factorial   =      !(j)
             factorial_R =     !r(j)
             fibonacci   =    fib(j)
             fibonacci_R =   fibR(j)
             hofstadterQ =  hofsQ(j)
             width       = length(j) + length(length(j**j))
             end   /*j*/

say  'number of invocations for ! (factorial) = '     ?.!
say  'number of invocations for !   recursive = '     ?.!r
say  'number of invocations for Fibonacci     = '     ?.fib
say  'number of invocations for Fib recursive = '     ?.fibR
say  'number of invocations for Hofstadter Q  = '     ?.hofsQ
say  'number of invocations for LENGTH        = '     ?.length
exit                                   /*stick a fork in it, we're done.*/

/*─────────────────────────────────────! (factorial) subroutine─────────*/
!: procedure expose ?.;   ?.!=?.!+1;  parse arg x;  !=1
                    do j=2  to x;     !=!*j;     end;             return !

/*─────────────────────────────────────!r (factorial) subroutine────────*/
!r: procedure expose ?.;  ?.!r=?.!r+1;  parse arg x;  if x<2 then return 1
    return x * !R(x-1)

/*──────────────────────────────────FIB subroutine (non─recursive)──────*/
fib: procedure expose ?.; ?.fib=?.fib+1;  parse arg n; na=abs(n); a=0; b=1
     if na<2  then  return na          /*test for couple special cases. */
             do j=2  to na;   s=a+b;   a=b;   b=s;   end
     if n>0 | na//2==1  then return  s /*if positive or odd negative... */
                        else return -s /*return a negative Fib number.  */

/*──────────────────────────────────FIBR subroutine (recursive)─────────*/
fibR: procedure expose ?.; ?.fibR=?.fibr+1; parse arg n; na=abs(n); s=1
      if na<2  then  return  na        /*handle a couple special cases. */
      if n <0  then  if n//2==0  then s=-1
      return (fibR(na-1)+fibR(na-2))*s

/*──────────────────────────────────HOFSQ subroutine (recursive)────────*/
hofsQ:  procedure expose ?.;  ?.hofsq=?.hofsq+1;   parse arg n
        if n<2  then return 1
        return  hofsQ(n - hofsQ(n - 1)) + hofsQ(n - hofsQ(n - 2))

/*──────────────────────────────────LENGTH subroutine───────────────────*/
length: procedure expose ?.;   ?.length=?.length+1
        return 'LENGTH'(arg(1))
