/*REXX program verifies that  all characters  in a string are all the same (character). */
@chr= '     [character'                               /* define a literal used for  SAY.*/
@all= 'all the same character for string (length'     /*    "   "    "     "    "    "  */
@.=                                              /*define a default for the  @.  array. */
parse arg x                                      /*obtain optional argument from the CL.*/
if x\=''  then       @.1= x                      /*if user specified an arg, use that.  */
          else do;   @.1=                        /*use this null string if no arg given.*/
                     @.2= '   '                  /* "    "          "    "  "  "    "   */
                     @.3= 2                      /* "    "          "    "  "  "    "   */
                     @.4= 333                    /* "    "          "    "  "  "    "   */
                     @.5= .55                    /* "    "          "    "  "  "    "   */
                     @.6= 'tttTTT'               /* "    "          "    "  "  "    "   */
                     @.7= 4444 444k              /* "    "          "    "  "  "    "   */
               end                               /* [↑]  seventh value contains a blank.*/

     do j=1;    L= length(@.j)                   /*obtain the length of an array element*/
     if j>1  &  L==0     then leave              /*if arg is null and  J>1, then leave. */
     r= allSame(@.j)                             /*R:  ≡0,  or the location of bad char.*/
     if r\==0  then ?= substr(@.j,r,1)           /*if  not  monolithic, obtain the char.*/
     if r==0   then say '   ' @all L"):"  @.j
               else say 'not' @all L"):"  @.j  @chr ?  "('"c2x(?)"'x)  at position"  r"]."
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
allSame: procedure; parse arg y                  /*get a value from the argument list.  */
         if y==''  then return 0                 /*if  Y  is null,  then return 0 (zero)*/
         return verify(y, left(y,1) )            /*All chars the same?   Return 0 (zero)*/
                                                 /*                else  return location*/
