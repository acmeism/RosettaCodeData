/*REXX program lists the prime factors of a specified integer  (or a range of integers).*/
@.=left('', 8);  @.0="{unity} ";  @.1='[prime] ' /*some tags  and  handy-dandy literals.*/
parse arg LO HI @ .                              /*get optional arguments from the C.L. */
if LO=='' | LO==","  then do; LO=1; HI=40;  end  /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI= LO                 /* "      "         "   "   "     "    */
if  @==''            then  @= 'x'                /* "      "         "   "   "     "    */
if length(@)\==1  then @= x2c(@)                 /*Not length 1?  Then use hexadecimal. */
tell= (HI>0)                                     /*if  HIGH  is positive, then show #'s.*/
HI= abs(HI)                                      /*use the absolute value for  HIGH.    */
w= length(HI)                                    /*get maximum width for pretty output. */
numeric digits max(9, w + 1)                     /*maybe bump the precision of numbers. */
#= 0                                             /*the number of primes found (so far). */
     do n=abs(LO)  to HI;          f= factr(n)   /*process a single number  or  a range.*/
     p= words( translate(f, ,@) )  -  (n==1)     /*P:  is the number of prime factors.  */
     if p==1  then #= # + 1                      /*bump the primes counter (exclude N=1)*/
     if tell  then say right(n, w)  '='  @.p  f  /*display if a prime, plus its factors.*/
     end   /*n*/
say
say right(#, w)          ' primes found.'        /*display the number of primes found.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
factr: procedure expose @; parse arg z 1 n,$;  if z<2  then return z   /*is Z too small?*/
           do  while z// 2==0;  $= $||@||2 ;   z= z%2 ;   end /*maybe add factor of   2 */
           do  while z// 3==0;  $= $||@||3 ;   z= z%3 ;   end /*  "    "     "    "   3 */
           do  while z// 5==0;  $= $||@||5 ;   z= z%5 ;   end /*  "    "     "    "   5 */
           do  while z// 7==0;  $= $||@||7 ;   z= z%7 ;   end /*  "    "     "    "   7 */
           do  while z//11==0;  $= $||@||11;   z= z%11;   end /*  "    "     "    "  11 */
           do  while z//13==0;  $= $||@||13;   z= z%13;   end /*  "    "     "    "  13 */
           do  while z//17==0;  $= $||@||17;   z= z%17;   end /*  "    "     "    "  17 */
           do  while z//19==0;  $= $||@||19;   z= z%19;   end /*  "    "     "    "  19 */
           do  while z//23==0;  $= $||@||23;   z= z%23;   end /*  "    "     "    "  23 */
           do  while z//29==0;  $= $||@||29;   z= z%29;   end /*  "    "     "    "  29 */
           do  while z//31==0;  $= $||@||31;   z= z%31;   end /*  "    "     "    "  31 */
           do  while z//37==0;  $= $||@||37;   z= z%37;   end /*  "    "     "    "  37 */
       if z>40 then do;    t= z;    q= 1;    r= 0;              do while q<=t;    q= q * 4
                                                                end   /*while*/
                      do while q>1; q=q%4;  _=t-r-q;  r=r%2; if _>=0  then do;  t=_; r=r+q
                                                                           end
                      end   /*while*/                    /* [↑]  find integer SQRT(z).  */
                                                         /*R:  is the integer SQRT of Z.*/
                      do j=41  by 6  to  r  while j<=z   /*insure J isn't divisible by 3*/
                      parse var j  ''  -1  _             /*get last decimal digit of  J.*/
                      if _\==5  then do  while z//j==0;      $=$||@||j;     z= z%j;    end
                      if _ ==3  then iterate             /*Next number  ÷  by 5 ?  Skip.*/
                      y= j + 2                           /*use the next (odd) divisor.  */
                                     do  while z//y==0;      $=$||@||y;     z= z%y;    end
                      end   /*j*/                        /* [↑]  reduce  Z  by  Y ?     */
                    end     /*if z>40*/

       if z==1  then return substr($,       1+length(@) )  /*Is residual=1?  Don't add 1*/
                     return substr($||@||z, 1+length(@) )  /*elide superfluous header.  */
