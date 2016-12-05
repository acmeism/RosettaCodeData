   ∙
   ∙
   ∙
/*──────────────────────────────────────────────────────────────────────────────────────*/
digRoot: procedure;  parse arg x 1 ox            /*get the number, also get another copy*/
             do pers=0  while length(x)\==1; $=0 /*keep summing until digRoot ≡ 1 digit.*/
                 do j=1  for length(x)           /*add each digit in the decimal number.*/
                 ?=substr(x, j, 1)               /*pick off a character, maybe a digit ?*/
                 if datatype(?, 'W')  then $=$+? /*add a decimal digit to digital root. */
                 end   /*j*/
             x=$                                 /*a  'new' num,  it may be multi-digit.*/
             end       /*pers*/
         say center(x,7)   center(pers,11)   ox  /*display a nicely formatted line.     */
         return
