/*REXX program supports the  Caesar cypher for the Latin alphabet only,  no punctuation */
/*──────────── or blanks allowed,  all lowercase Latin letters are treated as uppercase.*/
parse arg key .;  arg . p                        /*get key & uppercased text to be used.*/
p=space(p,0)                                     /*elide any and all spaces (blanks).   */
                    say 'Caesar cypher key:' key /*echo the Caesar cypher key to console*/
                    say '       plain text:' p   /*  "   "       plain text    "    "   */
y=Caesar(p, key);   say '         cyphered:' y   /*  "   "    cyphered text    "    "   */
z=Caesar(y,-key);   say '       uncyphered:' z   /*  "   "  uncyphered text    "    "   */
if z\==p  then say  "plain text doesn't match uncyphered cyphered text."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Caesar: procedure; arg s,k;  @='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        ak=abs(k)                                /*obtain the absolute value of the key.*/
        L=length(@)                              /*obtain the length of the  @  string. */
        if ak>length(@)-1 | k==0  then  call err k  'key is invalid.'
        _=verify(s,@)                            /*any illegal characters specified ?   */
        if _\==0  then call err 'unsupported character:'   substr(s, _, 1)
        if k>0    then ky=k+1                    /*either cypher it,  or ···            */
                  else ky=L+1-ak                 /*     decypher it.                    */
        return translate(s, substr(@||@,ky,L),@) /*return the processed text.           */
/*──────────────────────────────────────────────────────────────────────────────────────*/
err:    say;      say '***error***';       say;          say arg(1);      say;     exit 13
