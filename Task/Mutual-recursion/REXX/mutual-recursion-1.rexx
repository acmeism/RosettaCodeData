/*REXX program shows mutual recursion (via Hofstadter Male & Female seq)*/
parse arg lim .;            if lim=''  then lim=40;      pad=left('',20)

       do j=0  to lim;  jj=Jw(j);     ff=F(j);       mm=M(j)
       say    pad   'F('jj") ="    Jw(ff)    pad    'M('jj") ="    Jw(mm)
       end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────F, M, Jw  subroutines────────────*/
F:  procedure; parse arg n;   if n==0  then return 1;   return n-M(F(n-1))
M:  procedure; parse arg n;   if n==0  then return 0;   return n-F(M(n-1))
Jw: return right(arg(1),length(lim))   /*right justifies # for nice look*/
