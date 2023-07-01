/*REXX program splits a string based on change of character ───► a comma delimited list.*/
parse arg str                                    /*obtain optional arguments from the CL*/
if str==''  then str= 'gHHH5YY++///\'            /*Not specified?  Then use the default.*/
p=left(str, 1)                                   /*placeholder for the "previous" string*/
$=                                               /*     "       "   "    output      "  */
     do j=1  for length(str);  @=substr(str,j,1) /*obtain a character from the string.  */
     if @\==p  then $=$', '                      /*Not replicated char? Append delimiter*/
     p=@;           $=$ || @                     /*append a character to the  $  string.*/
     end   /*j*/                                 /* [↓]  keep peeling chars until done. */
say '          input string: '      str          /*display the original string & output.*/
say '         output string: '      $            /*stick a fork in it,  we're all done. */
