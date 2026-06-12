/*REXX program finds the  longest common suffix  contained in an array of strings.      */
parse arg z;          z= space(z)                /*obtain optional arguments from the CL*/
if z==''|z==","  then z='baabababc baabc bbbabc' /*Not specified?  Then use the default.*/
z= space(z);      #= words(z)                    /*#:  the number of words in the list. */
say 'There are '  #  " words in the list: "  z
zr= reverse(z)                                   /*reverse Z, find longest common prefix*/
@= word(zr, 1);       m= length(@)               /*get 1st word in reversed string; len.*/

     do j=2  to #;    x= word(zr, j)             /*obtain a word (string) from the list.*/
     t= compare(@, x)                            /*compare to the "base" word/string.   */
     if t==1          then do;  @=;  leave       /*A mismatch of strings?   Then leave, */
                           end                   /*no sense in comparing anymore strings*/
     if t==0 & @==x   then t= length(@) + 1      /*Both strings equal?  Compute length. */
     if t>=m  then iterate                       /*T ≥ M?  Then it's not longest string.*/
     m= t - 1;        @= left(@, max(0, m) )     /*redefine max length & the base string*/
     end   /*j*/
say                                              /*stick a fork in it,  we're all done. */
if m==0  then say 'There is no common suffix.'
         else say 'The longest common suffix is: '   right( word(z, 1), m)
