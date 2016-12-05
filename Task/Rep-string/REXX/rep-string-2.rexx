/*REXX pgm determines  if  a string is a repString, it returns minimum length repString.*/
parse arg s                                      /*get optional strings from the C.L.   */
if s=''  then s=1001110011 1110111011 0010010010 1010101010 1111111111 0100101101 0100100 101 11 00 1 45
                                                 /* [↑]  S  not specified?  Use defaults*/
     do k=1  for words(s);   _=word(s,k);   w=length(_)       /*process binary strings. */
     say right(_,max(25,w))  repString(_)                     /*show repString & result.*/
     end   /*k*/                                 /* [↑]  the  "result"  may be negatory.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
repString: procedure;  parse arg x;              L=length(x);         @rep='  rep string='
           if \datatype(x,'B')  then return "  ***error***  string isn't a binary string."
           h=L%2
                  do j=1  for L-1  while  j<=h;        $=left(x,j);     $$=copies($,L)
                  if left($$,L)==x  then  return @rep    left($,15)     "[length"     j']'
                  end   /*j*/                    /* [↑]  we have found a good repString.*/
           return               '      (no repetitions)'    /*failure to find repString.*/
