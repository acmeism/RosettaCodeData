/*REXX program can  generate and display several  EKG  sequences  (with various starts).*/
parse arg nums start                             /*obtain optional arguments from the CL*/
if  nums=='' |  nums==","  then  nums= 50        /*Not specified?  Then use the default.*/
if start= '' | start= ","  then start=2 5 7 9 10 /* "      "         "   "   "     "    */

     do s=1  for words(start);   $=              /*step through the specified  STARTs.  */
     second= word(start, s);     say             /*obtain the second integer in the seq.*/

         do j=1  for nums
         if j<3  then do; #=1;  if j==2  then #=second;  end   /*handle 1st & 2nd number*/
                 else #= ekg(#)
         $= $ right(#,  max(2, length(#) ) )     /*append the EKG integer to the $ list.*/
         end   /*j*/                             /* [↑] the RIGHT BIF aligns the numbers*/
     say '(start'  right(second,  max(2, length(second) ) )"):"$      /*display EKG seq.*/
     end       /*s*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add_:   do  while z//j == 0;    z=z%j;    _=_ j;    w=w+1;    end;         return strip(_)
/*──────────────────────────────────────────────────────────────────────────────────────*/
ekg: procedure expose $; parse arg x 1 z,,_
     w=0                                                        /*W:  number of factors.*/
             do k=1  to 11  by 2;     j=k;  if j==1  then j=2   /*divide by low primes. */
             if j==9  then iterate;   call add_                 /*skip ÷ 9; add to list.*/
             end   /*k*/
                                                                /*↓ skips multiples of 3*/
             do y=0  by 2;  j= j + 2 + y//4                     /*increment J by 2 or 4.*/
             parse var  j  ''  -1  r;  if r==5  then iterate    /*divisible by five ?   */
             if j*j>x | j>z  then leave                         /*passed the sqrt(x) ?  */
             _= add_()                                          /*add a factor to list. */
             end   /*y*/
     j=z;                    if z\==1  then _= add_()           /*Z¬=1? Then add──►list.*/
     if _=''  then _=x                                          /*Null? Then use prime. */
                 do   j=3;                          done=1
                   do k=1  for w
                   if j // word(_, k)==0  then do;  done=0;  leave;  end
                   end   /*k*/
                 if done  then iterate
                 if wordpos(j, $)==0  then return j             /*return an EKG integer.*/
                 end     /*j*/
