/*REXX program supports the Caesar cypher for most keyboard characters including blanks.*/
parse arg key p                                  /*get key and the text to be cyphered. */
                    say 'Caesar cypher key:' key /*echo the Caesar cypher key to console*/
                    say '       plain text:' p   /*  "   "       plain text    "    "   */
y=Caesar(p, key);   say '         cyphered:' y   /*  "   "    cyphered text    "    "   */
z=Caesar(y,-key);   say '       uncyphered:' z   /*  "   "  uncyphered text    "    "   */
if z\==p  then say  "plain text doesn't match uncyphered cyphered text."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Caesar: procedure;     parse arg s,k;     @= 'abcdefghijklmnopqrstuvwxyz'
        @=translate(@)@"0123456789(){}[]<>'"     /*add uppercase, digitss, group symbols*/
        @=@'~!@#$%^&*_+:";?,./`-= '              /*also add other characters to the list*/
        L=length(@)                              /*obtain the length of the  @  string. */
        ak=abs(k)                                /*obtain the absolute value of the key.*/
        if ak>length(@)-1 | k==0  then  call err k  'key is invalid.'
        _=verify(s,@)                            /*any illegal characters specified ?   */
        if _\==0  then call err 'unsupported character:'   substr(s, _, 1)
        if k>0    then ky=k+1                    /*either cypher it,  or ···            */
                  else ky=L+1-ak                 /*     decypher it.                    */
        return translate(s, substr(@ || @, ky, L),  @)
/*──────────────────────────────────────────────────────────────────────────────────────*/
err:    say;      say '***error***';       say;          say arg(1);      say;     exit 13
