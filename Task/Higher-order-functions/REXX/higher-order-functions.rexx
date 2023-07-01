/*REXX program demonstrates the  passing of a  name of a function  to another function. */
call function  'fact'   ,   6;           say right(    'fact{'$"} = ", 30)    result
call function  'square' ,  13;           say right(  'square{'$"} = ", 30)    result
call function  'cube'   ,   3;           say right(    'cube{'$"} = ", 30)    result
call function  'reverse', 721;           say right( 'reverse{'$"} = ", 30)    result
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cube:     return $**3
fact:     procedure expose $;  !=1;      do j=2  to $;    !=!*j;     end;         return !
function: arg ?.;   parse arg ,$;        signal value (?.)
reverse:  return 'REVERSE'($)
square:   return $**2
