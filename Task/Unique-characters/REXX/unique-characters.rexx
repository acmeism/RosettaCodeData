/*REXX pgm finds and shows characters that are unique to only one string  and once only.*/
parse arg $                                      /*obtain optional arguments from the CL*/
if $='' | $=","  then $= '133252abcdeeffd'  "a6789798st"  'yxcdfgxcyz'   /*use defaults.*/
if $=''  then do;   say "***error*** no lists were specified.";   exit 13;   end
@=                                               /*will be a list of all unique chars.  */

    do j=0  for 256;     x= d2c(j)               /*process all the possible characters. */
                         if x==' '  then iterate /*ignore blanks which are a delimiter. */
    _= pos(x, $);        if _==0    then iterate /*character not found,  then skip it.  */
    _= pos(x, $, _+1);   if _ >0    then iterate /*Character is a duplicate?  Skip it.  */
    @= @ x
    end   /*j*/                                  /*stick a fork in it,  we're all done. */

@@= space(@, 0);         L= length(@@)           /*elided superfluous blanks; get length*/
if @@==''  then @= " (none)"                     /*if none were found, pretty up message*/
if L==0    then L= "no"                          /*do the same thing for the # of chars.*/
say 'unique characters are: '   @                /*display the unique characters found. */
say
say 'Found '   L   " unique characters."         /*display the # of unique chars found. */
