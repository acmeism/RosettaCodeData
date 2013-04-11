/*REXX program to  list  non-continuous subsequences (NCS), given a seq.*/
parse arg list                               /*the the list from the CL.*/
if list=''  then list=1 2 3 4 5              /*Specified?  Use default. */
say 'list=' space(list);     say             /*show list to the terminal*/
w=words(list)          ;     #=0             /*# words in list; # of NCS*/
$=left(123456789,w)                          /*build a string of digits.*/
tail=right($,max(0,w-2))                     /*construct a "fast" tail. */

  do j=13  to left($,1) || tail              /*step through the list.   */
  if verify(j,$)\==0  then iterate           /*Not one of the chosen?   */
  f=left(j,1)                                /*the first digit of j.    */
  NCS=0                                      /*not non-continuous subseq*/
        do k=2 to length(j); _=substr(j,k,1) /*pick off a single digit. */
        if _ <=  f    then iterate j         /*if next digit ≤ then skip*/
        if _ \== f+1  then NCS=1             /*it's OK as of now.       */
        f=_                                  /*we now got a new next dig*/
        end   /*k*/

  if \NCS  then iterate                      /*¬OK?  Then skip this num.*/
  #=#+1                                      /*Eureka!    We found one. */
  x=                                         /*the beginning of the NCS.*/
        do m=1  for length(j)                /*build a thingy to display*/
        x=x word(list,substr(j,m,1))         /*pick off a number to show*/
        end   /*m*/

  say 'a non-continuous subsequence: '   x   /*show a non-cont. subseq. */
  end     /*j*/

if #==0  then #='no'                         /*make it more gooder Eng. */
say;     say #   "non-continuous subsequence"s(#)    'were found.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S  subroutine───────────────────────*/
s:  if arg(1)==1 then return '';   return word(arg(2) 's',1)  /*plurals.*/
