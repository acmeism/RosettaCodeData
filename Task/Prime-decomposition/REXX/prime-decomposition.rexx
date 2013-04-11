/*REXX program fins the prime factors of a (or some) positive integer(s)*/
numeric digits 100                     /*bump up precision of the nums. */
parse arg low high .                   /*get the argument(s).           */
if  low==''  then  low=1               /*no  LOW?    Then make one up.  */
if high==''  then high=low             /*no HIGH?    Then make one up.  */
w=length(high)                         /*get max width for pretty tell. */
                do n=low  to high      /*process single number | a range*/
                say right(n,w)  'prime factors ='  factr(n)
                end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FACTR subroutine────────────────────*/
factr: procedure; parse arg x 1 z,,list /*sets X&Z to arg1, LIST to null*/
if x <1  then return ''                /*Too small?    Then return null.*/
if x==1  then return 1                 /*special case for unity.        */

    do j=2 to 5; if j\==4 then call buildF; end  /*fast builds for list.*/
j=5                                    /*start were we left off  (J=5). */
      do y=0  by 2;     j=j+2+y//4     /*insure it's not divisible by 3.*/
      if right(j,1)==5  then iterate   /*fast check  for divisible by 5.*/
      if   j>z          then leave     /*num. reduced to a small number?*/
      if j*j>x          then leave     /*are we higher than the √ of X ?*/
      call buildF                      /*add a prime factor to list (J).*/
      end   /*y*/

if z==1  then return strip(list)       /*if residual=unity, don't append*/
              return strip(list z)     /*return list,  append residual. */
/*──────────────────────────────────BUILDF subroutine───────────────────*/
buildF: do forever                     /*keep dividing until it hurts.  */
        if z//j\==0  then return       /*can't divide any more?         */
        list=list j                    /*add number to the list  (J).   */
        z=z%j                          /*do an integer divide.          */
        end   /*forever*/
