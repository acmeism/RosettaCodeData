/*REXX program to display the  numbers  for the  "look and say"  series.*/
arg nums .                             /*get optional number of numbers.*/
if nums==''  then nums=10              /*Not specified?  Then assume 10.*/
!=                                     /*start with empty (null) series.*/
       do j=1  for nums                /*repeat a # times to show  NUMS.*/
       !=$lookandsay(!)                /*invoke sub to calculate next #.*/
       say !                           /*show the number to the screen. */
       end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────$LOOKANDSAY subroutine──────────────*/
$lookandsay: procedure; parse arg x,,$ /*define the argument passed (x).*/
if x==''  then return 1                /*Null?   Then assume 1st number.*/
x=x'.'                                 /*append decimal point as a stop.*/
j=1                                    /*start with the  Jth  char in X.*/
           do forever                  /*now, process the given sequence*/
           y=substr(x,j,1)             /*pick off one char to examine.  */
           if y=='.'  then leave       /*if we're at the end, then done.*/
           _=verify(x,y,,j) - j        /*see how many chars we have of X*/
           $=$ || _ || y               /*build the "say" thingy list.   */
           j=j  + _                    /*now, point to the next char.   */
           end   /*forever*/
return $                               /*return the  "say"  char string.*/
