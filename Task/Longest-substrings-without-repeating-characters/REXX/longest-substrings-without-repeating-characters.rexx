/*REXX pgm finds the longest substring (in a given string) without a repeating character*/
parse arg $                                      /*obtain optional argument from the CL.*/
if $=='' | $==","  then $= 'xyzyabcybdfd'        /*Not specified?  Then use the default.*/
L= length($)                                     /*L:    the length of the given string.*/
maxL= 0                                          /*MAXL: max length substring  (so far).*/
@.=                                              /*array to hold the max len substrings.*/
     do   j=1  for L;    b= substr($, j, 1)      /*search for max length substrings.    */
     x=                                          /*X:   the substring, less the 1st char*/
        do k=j+1  to L;  x= x || substr($, k, 1) /*search for the max length substrings.*/
        if \OKx(x)  then iterate j               /*Are there an replications?  Skip it. */
        _= length(x);  if _<maxL  then iterate   /*is length less then the current max? */
        @._= @._  x;   maxL= _                   /*add this substring to the max list.  */
        end   /*k*/
     end      /*j*/

say 'longest substring's(words(@.maxL))     "in "     $     ' ───► '    @.maxL
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:    if arg(1)==1  then return arg(3);  return word(arg(2) 's', 1)  /*simple pluralizer*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
OKx:  procedure;  parse arg y;     do r=1  for length(y)-1   /*look for duplicate chars.*/
                                   if pos(substr(y, r, 1), y, r+1)>0  then return 0
                                   end   /*r*/;                            return 1
