/*REXX pgm: Caesar cypher for almost all keyboard chars including blanks*/
parse arg key p                        /*get key and text to be cyphered*/
                        say 'Caesar cypher key:' key
                        say '       plain text:' p
y=caesar(p, key)      ; say '         cyphered:' y
z=caesar(y,-key)      ; say '       uncyphered:' z
if z\==p then say "plain text doesn't match uncyphered cyphered text."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CAESAR subroutine───────────────────*/
caesar:  procedure;     parse arg s,k;     @='abcdefghijklmnopqrstuvwxyz'
@=translate(@)@'0123456789(){}[]<>'    /*add uppercase, digs, group symb*/
@=@'~!@#$%^&*_+:";?,./`-= '''          /*add other characters here.     */
                       /*last char is doubled, REXX quoted syntax rules.*/
L=length(@)
ak=abs(k)
if ak>length(@)-1 | k==0 then call err k 'key is invalid'
_=verify(s,@)                          /*any illegal char specified ?   */
if _\==0 then call err 'unsupported character:' substr(s,_,1)
if k>0 then ky=k+1
       else ky=L+1-ak
return translate(s,substr(@||@,ky,L),@)
/*──────────────────────────────────ERR subroutine──────────────────────*/
err:   say;    say '***error!***';    say;    say arg(1);   say;   exit 13
