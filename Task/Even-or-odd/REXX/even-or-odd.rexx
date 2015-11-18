/*REXX program  tests and displays   if  an  integer  is    even    or    odd.*/
!.=0;   do j=0 by 2 to 8;  !.j=1;  end /*assign  0,2,4,6,8  to a "true" value.*/
                                       /* [↑]  assigns even digits to  "true".*/
numeric digits 1000                    /*handle most huge numbers from the CL.*/
parse arg x _ .                        /*get an argument from the command line*/
if x==''               then call terr "no input integer."             /*error.*/
if _\=='' | arg()\==1  then call terr "too many arguments: " _ arg(2) /*error.*/
if \datatype(x,'N')    then call terr x " isn't numeric."             /*error.*/
if \datatype(x,'W')    then call terr x " isn't an integer."          /*error.*/
y=abs(x)/1                             /*in case  X  is negative or malformed,*/
                                       /* [↑]  remainder of neg # might be -1.*/
                                       /*malformed #s: 007  9.0  4.8e1  .21e2 */
         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'remainder method (oddness)'
if y//2  then say  x  'is odd'
         else say  x  'is even'
                                       /* [↑]  uses division to get remainder.*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'rightmost digit using BIF (not evenness)'
_=right(y,1)
if pos(_,86420)==0  then say x 'is odd'
                    else say x 'is even'
                                       /* [↑]  uses 2 BIF (built─in functions)*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'rightmost digit using BIF (evenness)'
_=right(y,1)
if pos(_,86420)\==0  then say x 'is even'
                     else say x 'is odd'
                                       /* [↑]  uses 2 BIF (built─in functions)*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'even rightmost digit using array (evenness)'
_=right(y,1)
if !._  then say x 'is even'
        else say x 'is odd'
                                       /* [↑]  uses a BIF (built─in function).*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'remainder of division via function invoke (evenness)'
if even(y)  then say x 'is even'
            else say x 'is odd'
                                       /* [↑]  uses (even) function invocation*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'remainder of division via function invoke (oddness)'
if odd(y)  then say x 'is odd'
           else say x 'is even'
                                       /* [↑]  uses (odd)  function invocation*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'rightmost digit using BIF (not oddness)'
_=right(y,1)
if pos(_,13579)==0  then say x 'is even'
                    else say x 'is odd'
                                       /* [↑]  uses 2 BIF (built─in functions)*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'rightmost (binary) bit (oddness)'
if right(x2b(d2x(y)),1)  then say x 'is odd'
                         else say x 'is even'
                                       /* [↑]  requires extra numeric digits. */

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'parse statement using BIF (not oddness)'
parse var y '' -1 _                    /*obtain last decimal digit of the Y #.*/
if pos(_,02468)==0  then say x 'is odd'
                    else say x 'is even'
                                       /* [↑]  uses a BIF (built─in function).*/

         /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
call sayr 'parse statement using array (evenness)'
parse var y '' -1 _                    /*obtain last decimal digit of the Y #.*/
if !._  then say  x  'is even'
        else say  x  'is odd'
                                       /* [↑]  this is the fastest algorithm. */
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────one─liner subroutines─────────────────────*/
even: return \ ( arg(1)//2 )           /*actual algorithm used can be varied. */
even: return     arg(1)//2 == 0        /*   "       "       "   "   "    "    */
even: parse arg '' -1 _;  return !._   /*   "       "       "   "   "    "    */
odd:  return   arg(1)//2               /*   "       "       "   "   "    "    */
sayr: say;   say center('using the' arg(1), 79, '═');                    return
terr: say;   say '***error!***';    say;    say arg(1);    say;          exit 13
