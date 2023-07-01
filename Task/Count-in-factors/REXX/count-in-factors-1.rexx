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
           do  while z//2==0;   $= $||@||2;   z= z%2;    end  /*maybe add factor of   2 */
           do  while z//3==0;   $= $||@||3;   z= z%3;    end  /*  "    "     "    "   3 */
           do  while z//5==0;   $= $||@||5;   z= z%5;    end  /*  "    "     "    "   5 */
           do  while z//7==0;   $= $||@||7;   z= z%7;    end  /*  "    "     "    "   7 */

         do j=11  by 6  while j<=z               /*insure that  J  isn't divisible by 3.*/
         parse var j  ''  -1  _                  /*get the last decimal digit of  J.    */
         if _\==5  then do while  z//j==0;  $=$||@||j;  z= z%j;  end   /*maybe reduce Z.*/
         if _ ==3  then iterate                  /*Next # ÷ by 5?  Skip.     ___        */
         if j*j>n  then leave                    /*are we higher than the   √ N   ?     */
         y= j + 2                                /*obtain the next odd divisor.         */
                        do while  z//y==0;  $=$||@||y;  z= z%y;   end  /*maybe reduce Z.*/
         end   /*j*/
       if z==1  then return substr($,       1+length(@) )  /*Is residual=1?  Don't add 1*/
                     return substr($||@||z, 1+length(@) )  /*elide superfluous header.  */
