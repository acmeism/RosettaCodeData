/*REXX programs spells out  ordinal numbers  (in English, using the American system).   */
numeric digits 3000                              /*just in case the user uses gihugic #s*/
parse arg n                                      /*obtain optional arguments from the CL*/

if n='' | n=","  then n= 1  2  3  4  5  11  65  100  101  272  23456  8007006005004003

pgmOpts= 'ordinal  quiet'                        /*define options needed for $SPELL#.REX*/


     do j=1  for words(n)                        /*process each of the specified numbers*/
     x=word(n, j)                                /*obtain a number from the input list. */
     os=$spell#(x  pgmOpts)                      /*invoke REXX routine to spell ordinal#*/
     say right(x, max(20, length(x) ) )      ' spelled ordinal number ───► '      os
     end   /*j*/
