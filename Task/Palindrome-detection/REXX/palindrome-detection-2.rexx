/*REXX pgm checks if phrase is palindromic; ignores blanks, case, punct.*/
parse arg y                            /*get (optional) phrase from C.L.*/

if y=''  then y='In girum imus nocte et consumimur igni.'         /*[↓] translation.*/
               /*We walk around in the night and we are burnt by the fire (of love).*/

say 'string = ' y
say
if isPal(y)  then say 'The string is palindromic.'
             else say "The string isn't palindromic."
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────ISPAL subroutine────────────────────*/
isPal:  procedure;  arg x;  z=         /*uppercases the value of arg  X.*/
                                       /* [↓]   more letters from  ···  */
$='ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜáíóúñÑαßΓπΣσµτΦΘΩδφε'  /*··· codepage 437.*/

    do j=1  for length(x)              /*process the whole of the string*/
    _=substr(x,j,1)                    /*extract just a single character*/
    if datatype(_,'U') | pos(_,$)\==0  then z=z||_   /*append if letter.*/
    end   /*j*/

return z==reverse(z)                   /*returns  1  if exactly equal,  */
                                       /*   "     0  if   not   equal.  */
