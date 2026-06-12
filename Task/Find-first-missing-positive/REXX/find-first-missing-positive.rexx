/*REXX program finds the smallest missing positive integer in a given list of integers. */
parse arg a                                      /*obtain optional arguments from the CL*/
if a='' | a=","  then a= '[1,2,0]  [3,4,-1,1]  [7,8,9,11,12]  [1,2,3,4,5]' ,
                         "[-6,-5,-2,-1]  [5,-5]  [-2]  [1]  []"    /*maybe use defaults.*/
say 'the smallest missing positive integer for the following sets is:'
say
    do j=1  for words(a)                         /*process each set  in  a list of sets.*/
    set= translate( word(a, j), ,'],[')          /*extract   a   "  from "   "   "   "  */
    #= words(set)                                /*obtain the number of elements in set.*/
    @.= .                                        /*assign default value for set elements*/
           do k=1  for #;  x= word(set, k)       /*obtain a set element  (an integer).  */
           @.x= x                                /*assign it to a sparse array.         */
           end   /*k*/

           do m=1  for #  until @.m==.           /*now, search for the missing integer. */
           end   /*m*/
    if @.m==''  then m= 1                        /*handle the case of a  "null"  set.   */
    say right( word(a, j), 40)   ' ───► '   m    /*show the set and the missing integer.*/
    end          /*j*/                           /*stick a fork in it,  we're all done. */
