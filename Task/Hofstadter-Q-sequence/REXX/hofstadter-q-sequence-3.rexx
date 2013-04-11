/*REXX program to generate  Hofstadter  Q    sequence for any  N.       */
q.=0;   q.1=1;   q.2=1        /*negative #s won't have values displayed.*/
call HofstadterQ       10
call HofstadterQ    -1000;     say;     say '1000th value='result;     say
call HofstadterQ  -100000
downs=0;                       do j=2  to 100000;            jm=j-1
                               downs=downs + (q.j<q.jm)
                               end

say downs  'terms are less then the previous term.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HofstadterQ subroutine──────────────*/
HofstadterQ: procedure expose q.; arg x 1 ox  /*get the # to gen through*/
                                       /*(above)  OX  is the same as  X.*/
x=abs(x)                               /*use the absolute value for  X. */
L=length(x)                            /*use for right justified output.*/
             do j=1  for x
             if q.j==0  then q.j=QR(j) /*Not defined?    Then define it.*/
             if ox>0    then say right(j,L) right(q.j,L)  /*if X>0, tell*/
             end    /*j*/
return q.x                             /*return the  Xth term to caller.*/
/*──────────────────────────────────QR subroutine───────────────────────*/
QR:  procedure expose q.;   parse arg n       /*function is recursive.  */
if q.n==0  then q.n=QR(n-QR(n-1)) + QR(n-QR(n-2))  /*¬defined? Define it*/
return q.n                                    /*return with the value.  */
