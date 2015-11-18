/*REXX program performs prime decomposition for a range of positive integer(s)*/
numeric digits 1000                    /*handle thousand digits for the powers*/
parse arg    bot top  step   base  add /*get optional arguments from the C.L. */
if  bot==''  then do;bot=1;top=100;end /*no  BOT given?  Then use the default.*/
if  top==''  then          top=bot     /* "  TOP?  "       "   "   "     "    */
if step==''  then step=1               /* " STEP?  "       "   "   "     "    */
if add ==''  then add=-1               /* "  ADD?  "       "   "   "     "    */
w=length(top)                          /*get maximum width for aligned display*/
if base\=='' then w=length(base**top)  /*will be testing powers of two later? */
@.=left('',7);    @.0='{unity}';  @.1='[prime]'    /*literals:  prime (or not)*/
numeric digits max(9,w+1)              /*maybe increase the digits precision. */
#=0                                    /*P:  is the number of primes found.   */
        do n=bot  to top  by step      /*process a single number  or  a range.*/
        ?=n;  if base\==''  then ?=base**n+add        /*do a "Mercenne" test? */
        pf=factr(?);     f=words(pf)   /*get prime factors; number of factors.*/
        if f==1  then #=#+1            /*Is N prime?  Then bump prime counter.*/
        say right(?,w)   right('('f")",9)   'prime factors: '  @.f   pf
iterate
        end   /*n*/
say
ps='primes';  if p==1  then ps='prime' /*setup for proper English in sentence.*/
say right(#,w+9+1)    ps    'found.'   /*display the number of primes found.  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
factr: procedure; parse arg x 1 z 1 d,$ /*set  X and Z  to argument; $ to null*/
if x==1  then return ''                /*handle the special case of X equal 1.*/
        do  while z//2==0;  $=$ 2;  z=z%2;  end  /*append all the  2  factors.*/
        do  while z//3==0;  $=$ 3;  z=z%3;  end  /*   "    "   "   3     "    */
        do  while z//5==0;  $=$ 5;  z=z%5;  end  /*   "    "   "   5     "    */
        do  while z//7==0;  $=$ 7;  z=z%7;  end  /*   "    "   "   7     "    */
                                                 /*                       ___ */
q=1;    do while q<=x;  q=q*4;  end              /*these 2 lines compute √ X  */
r=0;    do while q>1; q=q%4; _=d-r-q; r=r%2; if _>=0 then do; d=_;r=r+q;end; end

    do j=11  by 6  to r                /*insure that  J  isn't divisible by 3.*/
    parse var j  ''  -1  _             /*obtain the last decimal digit of  J. */
    if _\==5  then  do  while z//j==0;   $=$ j;   z=z%j;  end   /*maybe reduce*/
    if _ ==3  then iterate             /*if next  Y  is divisible by 5,  skip.*/
    y=j+2;          do  while z//y==0;   $=$ y;   z=z%y;  end   /*maybe reduce*/
    end   /*j*/
                                       /* [↓]  The $ list has a leading blank.*/
if z==1  then return $                 /*if residual=unity, then don't append.*/
              return $ z               /*return  $   with appended residual.  */
