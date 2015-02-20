/*REXX pgm determines if a str is a repStr, returns minimum len. repStr.*/
s=1001110011 1110111011 0010010010 1010101010 1111111111 0100101101 0100100 101 11 00 1
                                       /* [↑]  a list of binary strings.*/
     do k=1  for words(s); _=word(s,k) /*process all the binary strings.*/
     say  right(_,25)  repString(_)    /*show the original & the result.*/
     end   /*k*/                       /* [↑]  "result" may be negatory.*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────REPSTRING subroutine───────────────*/
repString:  procedure; parse arg x;    L=length(x);    r@= '  rep string='
   do j=1  for L-1  while  j<=L%2;     p=left(x,j)     /*WHILE tests max*/
   if left(copies(p,L),L)==x  then return r@   left(p,15)   '[length' j"]"
   end   /*j*/                         /* [↑]  we have found a repString*/
return  '      (no repetitions)'       /*(sigh)∙∙∙ a failure to find rep*/
