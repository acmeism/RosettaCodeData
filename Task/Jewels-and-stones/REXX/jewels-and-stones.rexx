/*REXX pgm counts how many letters (in the 1st string) are in common with the 2nd string*/
say  count('aAAbbbb', "aA")
say  count('ZZ'     , "z" )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
count: procedure;  parse arg stones,jewels       /*obtain the two strings specified.    */
       #= 0                                      /*initialize the variable  #  to  zero.*/
                   do j=1  for length(stones)    /*scan STONES for matching JEWELS chars*/
                   x= substr(stones, j, 1)       /*obtain a character of the STONES var.*/
                   if datatype(x, 'M')  then if pos(x, jewels)\==0  then #= # + 1
                   end   /*j*/                   /* [↑]  if a letter and a match, bump #*/
       return #                                  /*return the number of common letters. */
