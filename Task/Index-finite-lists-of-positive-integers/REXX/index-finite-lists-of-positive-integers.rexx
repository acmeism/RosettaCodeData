/*REXX program assigns an integer for a finite list of arbitrary non-negative integers. */
parse arg $                                      /*obtain optional argument  (int list).*/
if $='' | $=","  then $=3 14 159 265358979323846 /*Not specified?  Then use the default.*/
                                                 /* [↑]  kinda use decimal digits of pi.*/
$= translate( space($),   ',',   " ")            /*use a  commatized  list of integers. */
numeric digits max(9, 2 * length($) )            /*ensure enough dec. digits to handle $*/

                 say 'original list='   $        /*display the original list of integers*/
N=   rank($);    say '  map integer='   N        /*generate and display the map integer.*/
O= unrank(N);    say '       unrank='   O        /*generate original integer and display*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
rank:    return    x2d( translate( space( arg(1) ),  'c',  ",") )
unrank:  return  space( translate(   d2x( arg(1) ),  ',',  "C") )
