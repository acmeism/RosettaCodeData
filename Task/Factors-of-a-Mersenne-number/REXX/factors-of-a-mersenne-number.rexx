/*REXX program uses  exponent─and─mod  operator to test possible Mersenne numbers.      */
numeric digits 20                                /*this will be increased if necessary. */
parse arg N spec                                 /*obtain optional arguments from the CL*/
if    N=='' |  N==","     then    N=  88         /*Not specified?  Then use the default.*/
if spec=='' | spec==","   then spec= 920 970     /* "      "         "   "   "     "    */
      do j=1;      z=j                           /*process a range, & then do one more #*/
      if j=N  then j=word(spec, 1);              /*now, use  the high range of numbers. */
      if j>word(spec, 2)  then leave             /*done with the high range of numbers? */
      if \isPrime(z)  then iterate               /*if  Z  isn't a prime,  keep plugging.*/
      r=testMer(z)                               /*If Z is prime, give Z the 3rd degree.*/
      r=commas(r);    L=length(r)                /*add commas to R; get it's new length.*/
      if r==0  then say right('M'z, 10)  "──────── is a Mersenne prime."
               else say right('M'z, 50)  "is composite, a factor:"   right(r, max(L, 11) )
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _; do jc=length(_)-3  to 1  by -3; _=insert(',', _, jc); end;  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure; parse arg x;             if wordpos(x, '2 3 5 7') \== 0  then return 1
         if x<11  then return 0;             if x//2 == 0 | x//3       == 0  then return 0
              do j=5  by 6;                  if x//j == 0 | x//(j+2)   == 0  then return 0
              if j*j>x   then return 1                 /*◄─┐         ___                */
              end   /*j*/                              /*  └─◄ Is j>√ x ?  Then return 1*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt:   procedure; parse arg x;   #=1;      r=0;              do while #<=x;  #=#*4;  end
           do while #>1;  #=#%4;   _=x-r-#;  r=r%2;   if _>=0  then do;  x=_;  r=r+#;  end
           end   /*while*/                             /*iSqrt ≡    integer square root.*/
         return r                                      /*─────      ─       ──     ─  ─ */
/*──────────────────────────────────────────────────────────────────────────────────────*/
testMer: procedure;  parse arg x;              p=2**x  /* [↓]  do we have enough digits?*/
         $$=x2b( d2x(x) ) + 0
         if pos('E',p)\==0  then do; parse var p "E" _;  numeric digits _+2;  p=2**x;  end
         !.=1;  !.1=0;  !.7=0                          /*array used for a quicker test. */
         R=iSqrt(p)                                    /*obtain integer square root of P*/
                    do k=2  by 2;        q=k*x  +  1   /*(shortcut) compute value of Q. */
                    m=q // 8                           /*obtain the remainder when ÷ 8. */
                    if !.m               then iterate  /*M  must be either one or seven.*/
                    parse var q '' -1 _; if _==5  then iterate    /*last digit a five ? */
                    if q//3==0  then iterate                      /*divisible by three? */
                    if q//7==0  then iterate           /*      ____     "      " seven? */
                    if q>R               then return 0 /*Is q>√2**x ?   A Mersenne prime*/
                    sq=1;         $=$$                 /*obtain binary version from  $. */
                        do  until $=='';      sq=sq*sq
                        parse var $  _  2  $           /*obtain 1st digit and the rest. */
                        if _  then sq=(sq+sq) // q
                        end   /*until*/
                    if sq==1  then return q            /*Not a prime?   Return a factor.*/
                    end   /*k*/
