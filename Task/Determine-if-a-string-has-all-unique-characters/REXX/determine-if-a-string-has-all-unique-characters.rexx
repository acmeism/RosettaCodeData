/*REXX pgm determines if a string is comprised of all unique characters (no duplicates).*/
@.=                                              /*assign a default for the  @.  array. */
parse arg @.1                                    /*obtain optional argument from the CL.*/
if @.1=''  then do;   @.1=                       /*Not specified?  Then assume defaults.*/
                      @.2= .
                      @.3= 'abcABC'
                      @.4= 'XYZ ZYX'
                      @.5= '1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ'
                end

     do j=1;  if j\==1  &  @.j==''  then leave   /*String is null & not j=1?  We're done*/
     say copies('─', 79)                         /*display a separator line  (a fence). */
     say 'Testing for the string (length' length(@.j)"): "   @.j
     say
     dup= isUnique(@.j)
     say 'The characters in the string'   word("are aren't", 1 + (dup>0) )  'all unique.'
     if dup==0  then iterate
     ?= substr(@.j, dup, 1)
     say 'The character '  ?  " ('"c2x(?)"'x)  at position "  dup ,
                                 ' is repeated at position '  pos(?, @.j, dup+1)
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isUnique: procedure; parse arg x                          /*obtain the character string.*/
                       do k=1  to length(x) - 1           /*examine all but the last.   */
                       p= pos( substr(x, k, 1), x, k + 1) /*see if the Kth char is a dup*/
                       if p\==0  then return k            /*Find a dup? Return location.*/
                       end   /*k*/
          return 0                                        /*indicate all chars unique.  */
