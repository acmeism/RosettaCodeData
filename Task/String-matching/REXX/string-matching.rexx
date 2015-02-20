/*REXX program  demonstrates  some  basic   character string   testing. */
parse arg a b                          /*obtain A and B from the C.L.   */
say 'string  A = '   a                 /*display string  A  to terminal.*/
say 'string  B = '   b                 /*   "       "    B   "     "    */
say
if left(A,length(b))==b  then say 'string  A  starts with string  B'
                         else say "string  A  doesn't start with string  B"
say
                           /*another method,  however a wee bit obtuse. */
/*¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
if compare(a,b)==length(b) then say 'string A starts with string B'
                           else say "string A doesn't start with string B"
¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬*/
                                       /* [↑]  above is a big comment.  */
p=pos(b,a)
if p==0  then say "string  A  doesn't contain string  B"
         else say 'string  A  contains string  B  (starting in position' p")"
say
if right(A,length(b))==b  then say 'string  A  ends with string  B'
                          else say "string  A  doesn't end with string  B"
say
Ps='';   p=0;                    do  until  p==0
                                 p=pos(b, a, p+1)
                                 if p\==0  then Ps = Ps',' p
                                 end   /*until ···*/
Ps=space(strip(Ps, 'L', ","))
times=words(Ps)
if times==0  then say "string  A  doesn't contain string  B"
             else say 'string  A  contains string  B ',
                        times   'time'left('s',times>1),
                       "(at position"left('s', times>1)   Ps')'

                                       /*stick a fork in it, we're done.*/
