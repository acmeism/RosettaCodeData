/*REXX program shows mutual recursion (via Hofstadter Male & Female sequence).*/
parse arg lim .;     if lim=''  then lim=40;   w=length(lim);    pad=left('',20)

     do j=0  to lim;   jj=right(j,w);  ff=right(F(j),w);        mm=right(M(j),w)
     say   pad     'F('jj") ="         ff   pad   'M('jj") ="   mm
     end   /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
F: procedure;  parse arg n;   if n==0  then return 1;       return n - M(F(n-1))
M: procedure;  parse arg n;   if n==0  then return 0;       return n - F(M(n-1))
