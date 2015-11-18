/*REXX program calculates the  modular inverse  of an integer   X  modulo  Y. */
parse arg x y .                        /*obtain two integers from the C.L.    */
say  'modular inverse of '     x     " by "     y     ' ───► '      modInv(x,y)
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
modInv: parse arg a,b 1 ob;    ox=0
        $=1
        if b \= 1        then  do  while a>1
                               parse value  a/b  a//b  b  ox     with    q b a t
                               ox=$-q*ox;             $=trunc(t)
                               end    /*while a>1*/
        if $<0  then $=$+ob
        return $
