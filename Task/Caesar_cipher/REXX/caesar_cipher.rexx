/*REXX pgm: Caesar cypher: Latin alphabet only, no punctuation or blanks*/
/*     allowed,  all lowercase Latin letters are treated as uppercase.  */
arg key p                              /*get key and text to be cyphered*/
p=space(p,0)                           /*remove all blanks from text.   */
                        say 'Caesar cypher key:' key
                        say '       plain text:' p
y=caesar(p, key)      ; say '         cyphered:' y
z=caesar(y,-key)      ; say '       uncyphered:' z
if z\==p then say "plain text doesn't match uncyphered cyphered text."
exit                                   /*stick a fork in it, we're done.*/
/*ââââââââââââââââââââââââââââââââââCAESAR subroutineâââââââââââââââââââ*/
caesar: procedure; arg s,k; @='ABCDEFGHIJKLMNOPQRSTUVWXYZ'; L=length(@)
ak=abs(k)
if ak > length(@)-1  |  k==0  |  k==''   then  call err k 'key is invalid'
_=verify(s,@)                          /*any illegal char specified ?   */
if _\==0 then call err 'unsupported character:' substr(s,_,1)
                                       /*now that error checks are done:*/
if k>0 then ky=k+1                     /*either cypher it, or ...       */
       else ky=27-ak                   /*     decypher it.              */
return translate(s,substr(@||@,ky,L),@)
/*ââââââââââââââââââââââââââââââââââERR subroutineââââââââââââââââââââââ*/
err:   say;    say '***error!***';    say;    say arg(1);   say;   exit 13
