/*REXX pgm finds distinct palindromes contained in substrings  (decimal #s or strings). */
parse arg LO HI mL $$                            /*obtain optional arguments from the CL*/
if LO='' | LO=","  then LO= 100                  /*Not specified?  Then use the default.*/
if HI='' | HI=","  then HI= 125                  /* "      "         "   "   "     "    */
if mL='' | mL=","  then mL=   2                  /* "      "         "   "   "     "    */
if $$='' | $$=","  then $$= 9 169 12769 1238769 12346098769 1234572098769 123456832098769,
                            12345679432098769 1234567905432098769 123456790165432098769  ,
                            83071934127905179083 1320267947849490361205695,
                           'Do these strings contain a minimum two character palindrome?',
                           'amanaplanacanalpanama'         /*a man a plan a canal panama*/
w= length(HI)                                    /*max width of LO ──► HI for alignment.*/

       do j=LO  to HI;  #= Dpal(j, 1)            /*get # distinct palindromes, minLen=1 */
       say right(j, w)  ' has '  #    " palindrome"s(#)': '    $
       end   /*j*/

#= words($$);      if #==0  then exit 0          /*No special words/numbers?  Then exit.*/

       do m=1  for #;     w= max(w, length(word($$, m)))   /*find max width string in $$*/
       end   /*m*/
say
       do j=1  for #;     z= word($$, j)         /*obtain a string in the  $$  list.    */
       #= Dpal(z, mL)                            /*get # distinct palindromes, minLen=mL*/
       _= left(':', #>0); @has= ' has ';                     @of='of length'
       say right(z, w)    @has   #   " palindrome"s(#,,' ')  @of  mL  "or more"_  space($)
       end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:    if arg(1)==1  then return arg(3);    return word( arg(2) 's', 1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
Dpal: procedure expose @. !. $ w;  parse arg x, mL;    $=;   !.= 0;   #= 0;   L= length(x)
         do   j=1  for L                         /*test for primality for all substrings*/
           do k=1  to  L-j+1                     /*search for substrings (including  X).*/
           y= strip( substr(x, j, k) )           /*extract a substring from the X string*/
           if length(y)<mL | y\==reverse(y)  then iterate   /*too short or ¬palindromic?*/
           if \!.y  then do;  $= $ right(y, w);  !.y= 1;  #= # + 1;  end
           end   /*k*/
         end     /*j*/
      return #
