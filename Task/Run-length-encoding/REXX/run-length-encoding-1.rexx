/*REXX program  encodes and displays a string  by using a  run─length  encoding scheme. */
parse arg input .                                /*normally, input would be in a file.  */
default= 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'
if input=='' | input==","  then input=   default /*Not specified?  Then use the default.*/
encode= RLE(input) ;     say '  input='  input   /*encode input string;  display input. */
                         say 'encoded='  encode  /*                      display run─len*/
decode= RLD(encode);     say 'decoded='  decode  /*decode the run─len;   display decode.*/
if decode==input  then say 'OK'; else say "¬ OK" /*display yay or nay (success/failure).*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
err: say;    say "***error***  input data isn't alphabetic:"   c;       say;     exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
RLE: procedure;  parse arg x;     $=             /*$:  is the output string  (so far).  */
                        Lx= length(x)            /*get length of the plain text string. */
       do j=1  by 0  to Lx;  c= substr(x, j, 1)  /*obtain a character from plain text.  */
       if \datatype(c, 'M')  then call err       /*Character not a letter?  Issue error.*/
       r= 0                                      /*R:  is NOT the number of characters. */
                     do k=j+1  to Lx  while substr(x, k, 1)==c   /*while characters ≡ C */
                     r= r + 1                    /*bump the replication count for a char*/
                     end   /*k*/
       j= j + r + 1                              /*increment (add to) the DO loop index.*/
       if r==0  then $= $ ||      c              /*don't use  R  if it is equal to zero.*/
                else $= $ || r || c              /*add character to the encoded string. */
       end   /*j*/;                   return $   /*return the encoded string to caller. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
RLD: procedure;  parse arg x;     $=             /*$:  is the output string  (so far).  */
                        Lx= length(x)            /*get the length of the encoded string.*/
       do j=1  by 0  to Lx;  c= substr(x, j, 1)  /*obtain a character from run encoding.*/
       if \datatype(c, 'W')  then do;   $= $ || c;     j= j + 1;     iterate /*j*/
                                  end            /* [↑]  a loner char, add it to output.*/
       #= 1                                      /*          [↓]  W:  use a Whole number*/
              do k=j+1  to Lx  while datatype(substr(x,k,1), 'w') /*while numeric*/
              #= # + 1                           /*bump the count of the numeric chars. */
              end   /*k*/
       n= substr(x, j, #) + 1                    /*#:  the length of encoded character. */
       $= $  ||  copies( substr(x, k, 1), n)     /*N:  is now the number of characters. */
       j= j + # + 1                              /*increment the DO loop index by D+1.  */
       end   /*j*/;                   return $   /*return the decoded string to caller. */
