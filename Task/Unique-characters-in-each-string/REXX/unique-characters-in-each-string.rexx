/*REXX pgm finds and shows characters that are  unique in each string  and  once only.  */
parse arg $                                      /*obtain optional arguments from the CL*/
if $='' | $=","  then $= '1a3c52debeffd'   "2b6178c97a938stf"   '3ycxdb1fgxa2yz'
if $=''  then do;   say "***error*** no lists were specified.";   exit 13;   end
#= words($);                     $$=             /*#: # words in $; $$: $ with no blanks*/
              do i=1  for #;    !.i= word($, i)  /*for speed, build a list of words in $*/
              $$= $$  ||  !.i                    /*build a list of all the strings.     */
              end   /*i*/
@=                                               /*will be a list of all unique chars.  */
   do j=0  for 256;        x= d2c(j)             /*process all the possible characters. */
   if pos(x, $$)==0               then iterate   /*Char not found in any string in  $ ? */
           do k=1  for #;  _= pos(x, !.k)        /*examine each string in the  $  list. */
           if _==0                then iterate j /*Character not found?   Then skip it. */
           if pos(x, !.k, _+1)>0  then iterate j /*    "     is a dup?      "    "   "  */
           end   /*k*/
   @= @ x                                        /*append a character, append it to list*/
   end   /*j*/                                   /*stick a fork in it,  we're all done. */

@@= space(@, 0);                  L= length(@@)  /*elided superfluous blanks; get length*/
if @@==''  then @= " (none)"                     /*if none were found, pretty up message*/
if L==0    then L= "no"                          /*do the same thing for the # of chars.*/
say 'unique characters are: '     @              /*display the unique characters found. */
say
say 'Found '    L    " unique characters."       /*display the # of unique chars found. */
