/*REXX program calculates    N   number of  Bernoulli numbers  expressed as  fractions. */
parse arg N .;   if N==''  then N=60             /*Not specified?  Then use the default.*/
!.=0;   w=max(length(N),4);  Nw=N+N%5            /*used for aligning (output) fractions.*/
say 'B(n)'   center("Bernoulli number expressed as a fraction", max(78-w, Nw))   /*title*/
say copies('─',w)   copies("─",max(78-w,Nw+2*w)) /*display 2nd line of title, separators*/
     do #=0  to  N                               /*process the numbers from  0  ──►  N. */
     b=bern(#);       if b==0  then iterate      /*calculate Bernoulli number, skip if 0*/
     indent=max(0, nW-pos('/', b))               /*calculate the alignment (indentation)*/
     say right(#, w)  left('', indent) b         /*display the indented Bernoulli number*/
     end   /*#*/                                 /* [↑]  align the Bernoulli fractions. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bern: parse arg x                                /*obtain the subroutine argument.      */
      if x==0  then return  '1/1'                /*handle the special case of  zero.    */
      if x==1  then return '-1/2'                /*   "    "     "      "   "  one.     */
      if x//2  then return   0                   /*   "    "     "      "   "  odds.    */
                                                 /* [↓]  process all numbers up to  X,  */
        do j=2  to x  by 2;  jp=j+1;   d=j+j     /*      ··· and set some shortcut vars.*/
        if d>digits()  then numeric digits d     /*increase the decimal digits if needed*/
        sn=1-j                                   /*set the  numerator.                  */
        sd=2                                     /* "   "   denominator.                */
                   do k=2  to j-1  by 2          /*calculate a  SN/SD  sequence.        */
                   parse var  @.k  bn  '/'  ad   /*get a previously calculated fraction.*/
                   an=comb(jp,k)*bn              /*use  COMBination  for the next term. */
                   $lcm=lcm(sd,ad)               /*use Least Common Denominator function*/
                   sn=$lcm%sd*sn;   sd=$lcm      /*calculate the   current  numerator.  */
                   an=$lcm%ad*an;   ad=$lcm      /*    "      "      next      "        */
                   sn=sn+an                      /*    "      "    current     "        */
                   end   /*k*/                   /* [↑]  calculate the  SN/SD  sequence.*/
        sn=-sn                                   /*adjust the sign for the numerator.   */
        sd=sd*jp                                 /*calculate           the denominator. */
        if sn\==1  then do;  _=gcd(sn, sd)       /*get the  Greatest Common Denominator.*/
                             sn=sn%_;  sd=sd%_   /*reduce the numerator and denominator.*/
                        end                      /* [↑]   done with the reduction(s).   */
        @.j=sn'/'sd                              /*save the result for the next round.  */
        end   /*j*/                              /* [↑]  done calculating Bernoulli #'s.*/

      return sn'/'sd
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb: procedure expose !.;  parse arg x,y;        if x==y  then return 1
      if !.!c.x.y\==0  then return !.!c.x.y               /*combination computed before?*/
      if x-y<y  then y=x-y; z=perm(x,y);          do j=2  to y;    z=z%j;    end
      !.!c.x.y=z;  return z                               /*assign memoization; return. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gcd:  procedure;            parse arg x,y;    x=abs(x)
        do  until  y==0;    parse value  x//y y  with  y x;  end;       return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
lcm:  procedure;            parse arg x,y;    x=abs(x);      return x*y/gcd(x,y)
/*──────────────────────────────────────────────────────────────────────────────────────*/
perm: procedure expose !.;  parse arg x,y;    z=1
      if !.!p.x.y\==0  then return !.!p.x.y               /*permutation computed before?*/
        do j=x-y+1  to x;   z=z*j;   end;     !.!p.x.y=z;               return z
