/*REXX program makes change from some amount with various specie (coins)*/
parse arg n $
if n='' then n=100                     /*Not specified?  Use $1 default.*/
if $='' then $=1 5 10 25               /*Use penny/nickle/dime/quarter ?*/
coins=words($)                         /*count number of coins specified*/
                 do j=1 for coins      /*create a fast way of accessing.*/
                 $.j=word($,j)         /*define a stemmed array element.*/
                 end   /*j*/

say  'with an amount of ' n",  there're " kaChing(n,coins),
     ' ways to make change with: ' $
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────kaChing subroutine──────────────────*/
kaChing:  procedure expose $.;   parse arg a,k
if a==0 then f=1                       /*unroll some special cases.     */
        else if k==0 | k==1 then f=0   /*unroll some more special cases.*/
                            else f=kaChing(a,k-1)   /*recurse the amount*/

if a==$.k        then return f+1       /*handle another special case.   */
if a<$.k | k==0  then return f         /*if amount is <coin, return  F. */
return f+kaChing(a-$.k,k)              /*keep recursing the diminished $*/
