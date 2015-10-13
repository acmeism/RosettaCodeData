/*REXX program generates   Hofstadter  Q    sequence for any  N.        */
parse arg a b c .                      /*get optional values from the CL*/
if \datatype(a,'W')  then a=      10   /*A not specified?   Use default.*/
if \datatype(b,'W')  then b=   -1000   /*B  "     "          "     "    */
if \datatype(c,'W')  then c= -100000   /*C  "     "          "     "    */
if \datatype(d,'W')  then d=-1000000   /*D  "     "          "     "    */
q.=1;                    ac= abs(c)    /* [↑]  neg #s don't show values.*/
call HofstadterQ  a
call HofstadterQ  b;   say;    say  abs(b)th(b)  'value is:'  result;  say
call HofstadterQ  c
downs=0;                      do j=2  for ac-1;   downs=downs+(q.j<q(j-1))
                              end   /*j*/

say downs  'terms are less then the previous term,'  ac||th(ac) 'term is:'  q.ac
call HofstadterQ  d;                     ad=abs(d);              say
say 'The'   ad || th(ad)   'term is'   q.ad
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HofstadterQ subroutine──────────────*/
HofstadterQ: procedure expose q.; parse arg x 1 ox  /*get # to gen thru.*/
                                       /* [↑]   OX    is the same as  X.*/
x=abs(x)                               /*use the absolute value for  X. */
w=length(x)                            /*use for right justified output.*/
             do j=1  for x
             if j>2   then  if q.j==1  then  q.j=q(j-q(j-1)) + q(j-q(j-2))
             if ox>0  then  say right(j,w) right(q.j,w)   /*if X>0, tell*/
             end    /*j*/
return q.x                             /*return the │X│th term to caller*/
/*──────────────────────────────────Q subroutine────────────────────────*/
q: parse arg ?;   return q.?           /*return value of Q.? to invoker.*/
/*──────────────────────────────────TH subroutine───────────────────────────────────────────────*/
th: procedure; parse arg x; x=abs(x); return word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
