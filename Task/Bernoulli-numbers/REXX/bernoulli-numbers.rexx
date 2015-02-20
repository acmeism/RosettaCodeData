/*REXX program calculates a number of Bernoulli numbers (as fractions). */
parse arg N .;   if N==''  then N=60   /*get N.  If ¬ given, use default*/
!.=0;   w=max(length(N),4);  Nw=N+N%5  /*used for aligning the output.  */
say 'B(n)' center('Bernoulli number expressed as a fraction', max(78-w,Nw))
say copies('─',w) copies('─', max(78-w,Nw+2*w))
     do #=0  to  N                     /*process numbers from  0 ──► N. */
     b=bern(#);  if b==0 then iterate  /*calculate Bernoulli#, skip if 0*/
     indent=max(0, nW-pos('/', b))     /*calculate alignment indentation*/
     say right(#,w)  left('',indent) b /*display the indented Bernoulli#*/
     end   /*#*/                       /* [↑] align the Bernoulli number*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BERN subroutine─────────────────────*/
bern: parse arg x                      /*obtain the subroutine argument.*/
if x==0  then return '1/1'             /*handle the special case of zero*/
if x==1  then return '-1/2'            /*   "    "     "      "   " one.*/
if x//2  then return 0                 /*   "    "     "      "   " odds*/
                                       /* [↓]  process all #s up to  X, */
  do j=2  to x  by 2;  jp=j+1;   d=j+j /*      & set some shortcut vars.*/
  if d>digits()  then numeric digits d /*increase precision if needed.  */
  sn=1-j                               /*set the numerator.             */
  sd=2                                 /* "   "  denominator.           */
             do k=2  to j-1  by 2      /*calculate a SN/SD sequence.    */
             parse var @.k bn '/' ad   /*get a previously calculated fra*/
             an=comb(jp,k)*bn          /*use COMBination for next term. */
             lcm=lcm.(sd,ad)           /*use Least Common Denominator.  */
             sn=lcm%sd*sn;   sd=lcm    /*calculate current numerator.   */
             an=lcm%ad*an;   ad=lcm    /*    "       next      "        */
             sn=sn+an                  /*    "     current     "        */
             end   /*k*/               /* [↑]  calculate SN/SD sequence.*/
  sn=-sn                               /*adjust the sign for numerator. */
  sd=sd*jp                             /*calculate the denominitator.   */
  if sn\==1  then do                   /*reduce the fraction if possible*/
                  _=gcd.(sn,sd)        /*get Greatest Common Denominator*/
                  sn=sn%_;  sd=sd%_    /*reduce numerator & denominator.*/
                  end                  /* [↑]   done with the reduction.*/
  @.j=sn'/'sd                          /*save the result for next round.*/
  end   /*j*/                          /* [↑]  done with calculating B#.*/

return sn'/'sd
/*──────────────────────────────────COMB subroutine─────────────────────*/
comb: procedure expose !.;  parse arg x,y;  if x==y  then return 1
if !.!c.x.y\==0  then return !.!c.x.y  /*combination computed before ?  */
      if x-y<y then y=x-y; z=perm(x,y);     do j=2  to y;    z=z%j;    end
!.!c.x.y=z;  return z                  /*assign memoization; then return*/
/*──────────────────────────────────GCD. subroutine (simplified)────────*/
gcd.: procedure;  parse arg x,y;    x=abs(x)
  do  until  y==0;   parse  value   x//y  y   with  y  x;  end;   return x
/*──────────────────────────────────LCM. subroutine (simplified)────────*/
lcm.: procedure; parse arg x,y; x=abs(x);             return x*y/gcd.(x,y)
/*──────────────────────────────────PERM subroutine─────────────────────*/
perm: procedure expose !.; parse arg x,y;  z=1
if !.!p.x.y\==0  then return !.!p.x.y  /*permutation computed before ?  */
      do j=x-y+1  to x;   z=z*j;   end;           !.!p.x.y=z;     return z
