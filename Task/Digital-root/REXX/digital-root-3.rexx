   ∙
   ∙
   ∙
/*──────────────────────────────────DIGROOT subroutine──────────────────*/
digRoot: procedure;  parse arg x 1 ox  /*get the num, save as original. */
  do pers=0  while length(x)\==1;  r=0 /*keep summing until digRoot=1dig*/
       do j=1  for length(x)           /*add each digit in the number.  */
       ?=substr(x,j,1)                 /*pick off a char, maybe a dig ? */
       if datatype(?,'W')  then r=r+?  /*add a digit to the digital root*/
       end   /*j*/
  x=r                                  /*'new' num, it may be multi-dig.*/
  end        /*pers*/
say center(x,7)  center(pers,11)  ox   /*show a nicely formatted line.  */
return
