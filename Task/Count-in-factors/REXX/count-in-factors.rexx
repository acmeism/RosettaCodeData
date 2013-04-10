/*REXX program finds and lists the prime factors of positive integer(s).*/
numeric digits 12                      /*bump precision of the numbers. */
parse arg low high .                   /*get the argument(s) from the CL*/
if high==''  then high=low             /*No HIGH?    Then make one up.  */
w=length(high)                         /*get max width for pretty tell. */
blanks=1                               /*allow spaces around the  "x".  */
         do n=low  to high             /*process single number | a range*/
         say right(n,w) '=' space(factr(n),blanks) /*display N & factors*/
         end   /*n*/                   /*if BLANKS=0, no spaces around X*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FACTR subroutine────────────────────*/
factr:  procedure;     parse arg x 1 z /*defines  X and Z  from the arg.*/
if x <1  then return ''                /*Invalid number?   Return null. */
if x==1  then return 1                 /*handle special case for unity. */
Xtimes= '∙'                            /*use round bullet for "times".  */
Xtimes= 'x'                            /*character used for "times" (x).*/
list=                                  /*nullify the list  (to empty).  */

  do j=2 to 5; if j\==4  then call .buildF; end  /*fast builds for list.*/
  j=5                                  /*start were we left off  (five).*/
       do y=0  by 2;     j=j+2+y//4    /*insure it's not divisible by 3.*/
       if right(j,1)==5  then iterate  /*fast check  for divisible by 5.*/
       if   j>z          then leave    /*number reduced to a small 'un? */
       if j*j>x          then leave    /*are we higher than the √ of X ?*/
       call .buildF                    /*add a prime factor to list (J).*/
       end    /*y*/

if z==1  then z=                       /*if residual is = 1, nullify it.*/
return strip(strip(list Xtimes z),,Xtimes)    /*elide any leading  "x". */
/*──────────────────────────────────.BUILDF subroutine──────────────────*/
.buildF:   do  while  z//j==0          /*keep dividing until it hurts.  */
           list=list Xtimes j          /*add number to the list  (J).   */
           z=z%j                       /*do an integer divide.          */
           end   /*while*/
return
