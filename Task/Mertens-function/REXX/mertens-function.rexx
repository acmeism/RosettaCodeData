/*REXX pgm computes & shows a value grid of the Mertens function for a range of integers*/
parse arg LO HI grp eqZ xZ .                     /*obtain optional arguments from the CL*/
if  LO=='' |  LO==","  then  LO=    0            /*Not specified?  Then use the default.*/
if  HI=='' |  HI==","  then  HI=  199            /* "      "         "   "   "     "    */
if grp=='' | grp==","  then grp=   20            /* "      "         "   "   "     "    */
if eqZ=='' | eqZ==","  then eqZ= 1000            /* "      "         "   "   "     "    */
if  xZ=='' |  xZ==","  then  xZ= 1000            /* "      "         "   "   "     "    */
call genP                                        /*generate primes up to max  √  HIHI   */
               call Franz LO, HI
if eqZ>0  then call Franz 1, -eqZ
if  xZ>0  then call Franz -1, xZ
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Franz: parse arg a 1 oa,b 1 ob;        @Mertens= ' The Mertens sequence from '
a= abs(a);   b= abs(b);    grid= oa>=0 & ob>=0   /*semaphore used to show a grid title. */
if grid  then say center(@Mertens LO " ──► " HI" ", max(50, grp*3), '═')    /*show title*/
         else say
zeros= 0                                         /*# of  0's found for Mertens function.*/
Xzero= 0                                         /*number of times that zero was crossed*/
$=;                 prev=                        /*$  holds output grid of GRP numbers. */
   do j=a  to b;     _= Mertens(j)               /*process some numbers from  LO ──► HI.*/
   if _==0  then zeros= zeros + 1                /*Is Zero?  Then bump the zeros counter*/
   if _==0  then if prev\==0 then Xzero= Xzero+1 /*prev ¬=0?   "   "    "  Xzero    "   */
   prev= _
   if grid  then $= $ right(_, 2)                /*build grid if A & B are non─negative.*/
   if words($)==grp  then do;  say substr($, 2);  $=    /*show grid if fully populated, */
                          end                           /*  and nullify it for more #s. */
   end   /*j*/                                   /*for small grids, using wordCnt is OK.*/

if $\==''  then say substr($, 2)                 /*handle any residual numbers not shown*/
if oa<0  then say @Mertens   a    " to "    b   ' has crossed zero '    Xzero    " times."
if ob<0  then say @Mertens   a    " to "    b   ' has '                 zeros    " zeros."
return
/*──────────────────────────────────────────────────────────────────────────────────────*/
Mertens: procedure expose @. !!. M.;  parse arg n; if M.n\==.  then return M.n
         if n<1  then return '∙'; m= 0           /*handle special cases of non─positive#*/
              do k=1  for n;   m= m + mobius(k)  /*sum the  MU's  up to  N.             */
              end   /*k*/                        /* [↑] mobius function uses memoization*/
         M.n= m;          return m               /*return the sum of all the  MU's.     */
/*──────────────────────────────────────────────────────────────────────────────────────*/
mobius: procedure expose @. !!.;  parse arg x 1 ox  /*get integer to be tested for  mu  */
        if !!.x\==.  then return !!.x            /*X computed before?  Return that value*/
        if x<1  then return '∙';      mu= 0      /*handle special case of non-positive #*/
             do k=1;  p= @.k; if p>x  then leave       /* (P)    > X?   Then we're done.*/
             if p*p>x    then do; mu= mu+1; leave; end /* (P**2) > X?   Bump # and leave*/
             if x//p==0  then do; mu= mu+1       /*X divisible by P?   Bump  mu  number.*/
                                  x= x % p       /*                    Divide by prime. */
                                  if x//p==0  then return 0  /*X÷by P?  Then return zero*/
                              end
             end   /*k*/                         /*MU (below) is almost always small, <9*/
        !!.ox=  -1 ** mu;         return !!.ox   /*raise -1 to the mu power, memoize it.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13 /*initialize some low primes; # primes.*/
      !!.=.;  M.=!!.;      #= 6;  sq.#= @.6**2   /*     "     2 arrays for memoization. */
       do j=@.#+4  by 2  to max(HI, eqZ, xZ); parse var j '' -1 _   /*odd Ps from now on*/
       if _==5 then iterate; if j//3==0 then iterate; if j//7==0  then iterate /*÷ 5 3 7*/
          do k=7  while sq.k<=j                  /*divide by some generated odd primes. */
          if j//@.k==0  then iterate j           /*Is J divisible by  P?  Then not prime*/
          end   /*k*/                            /* [↓]  a prime  (J)  has been found.  */
       #= #+1;          @.#=j;  sq.j= j*j        /*bump P count;  P──►@.;  compute  J**2*/
       end      /*j*/;                    return /*calculate the squares of some primes.*/
