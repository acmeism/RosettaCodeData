/*REXX pgm does prime decomposition of a range of positive integers (with a prime count)*/
numeric digits 1000                              /*handle thousand digits for the powers*/
parse arg  bot  top  step   base  add            /*get optional arguments from the C.L. */
if  bot==''   then do;  bot=1;  top=100;  end    /*no  BOT given?  Then use the default.*/
if  top==''   then              top=bot          /* "  TOP?  "       "   "   "     "    */
if step==''   then step=  1                      /* " STEP?  "       "   "   "     "    */
if add ==''   then  add= -1                      /* "  ADD?  "       "   "   "     "    */
tell= top>0;       top=abs(top)                  /*if TOP is negative, suppress displays*/
w=length(top)                                    /*get maximum width for aligned display*/
if base\==''  then w=length(base**top)           /*will be testing powers of two later? */
@.=left('', 7);   @.0="{unity}";   @.1='[prime]' /*some literals:  pad;  prime (or not).*/
numeric digits max(9, w+1)                       /*maybe increase the digits precision. */
#=0                                              /*#:    is the number of primes found. */
        do n=bot  to top  by step                /*process a single number  or  a range.*/
        ?=n;  if base\==''  then ?=base**n + add /*should we perform a "Mercenne" test? */
        pf=factr(?);      f=words(pf)            /*get prime factors; number of factors.*/
        if f==1  then #=#+1                      /*Is N prime?  Then bump prime counter.*/
        if tell  then say right(?,w)   right('('f")",9)   'prime factors: '     @.f     pf
        end   /*n*/
say
ps= 'primes';    if p==1  then ps= "prime"       /*setup for proper English in sentence.*/
say right(#, w+9+1)       ps       'found.'      /*display the number of primes found.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
factr: procedure;  parse arg x 1 d,$             /*set X, D  to argument 1;  $  to null.*/
if x==1  then return ''                          /*handle the special case of   X = 1.  */
       do  while x// 2==0;  $=$  2;  x=x%2;  end /*append all the  2  factors of new  X.*/
       do  while x// 3==0;  $=$  3;  x=x%3;  end /*   "    "   "   3     "     "  "   " */
       do  while x// 5==0;  $=$  5;  x=x%5;  end /*   "    "   "   5     "     "  "   " */
       do  while x// 7==0;  $=$  7;  x=x%7;  end /*   "    "   "   7     "     "  "   " */
       do  while x//11==0;  $=$ 11;  x=x%11; end /*   "    "   "  11     "     "  "   " */    /* ◄■■■■ added.*/
       do  while x//13==0;  $=$ 13;  x=x%13; end /*   "    "   "  13     "     "  "   " */    /* ◄■■■■ added.*/
       do  while x//17==0;  $=$ 17;  x=x%17; end /*   "    "   "  17     "     "  "   " */    /* ◄■■■■ added.*/
       do  while x//19==0;  $=$ 19;  x=x%19; end /*   "    "   "  19     "     "  "   " */    /* ◄■■■■ added.*/
       do  while x//23==0;  $=$ 23;  x=x%23; end /*   "    "   "  23     "     "  "   " */    /* ◄■■■■ added.*/
                                                 /*                                  ___*/
q=1;   do  while q<=x;  q=q*4;  end              /*these two lines compute integer  √ X */
r=0;   do  while q>1;   q=q%4;  _=d-r-q;  r=r%2;   if _>=0  then do; d=_; r=r+q; end;  end

       do j=29  by 6  to r                       /*insure that  J  isn't divisible by 3.*/    /* ◄■■■■ changed.*/
       parse var j  ''  -1  _                    /*obtain the last decimal digit of  J. */
       if _\==5  then  do  while x//j==0;  $=$ j;  x=x%j;  end     /*maybe reduce by J. */
       if _ ==3  then iterate                    /*Is next  Y  is divisible by 5?  Skip.*/
       y=j+2;          do  while x//y==0;  $=$ y;  x=x%y;  end     /*maybe reduce by J. */
       end   /*j*/
                                                 /* [↓]  The $ list has a leading blank.*/
if x==1  then return $                           /*Is residual=unity? Then don't append.*/
              return $ x                         /*return   $   with appended residual. */
