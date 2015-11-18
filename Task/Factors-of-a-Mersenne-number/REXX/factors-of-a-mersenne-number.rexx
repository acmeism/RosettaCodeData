/*REXX program uses exponent─&─mod operator to test possible Mersenne numbers.*/
numeric digits 500                     /*dealing with some ginormous numbers. */

      do j=1  to 61;  z=j              /*when J reaches 61, it turns into 929.*/
      if z==61        then z=929       /*now, a switcheroo, 61 turns into 929.*/
      if \isPrime(z)  then iterate     /*if  Z  isn't a prime,  keep plugging.*/
      r=testM(z)                       /*If Z is prime, give Z the 3rd degree.*/
      if r==0   then  say right('M'z,8)     "──────── is a Mersenne prime."
                else  say right('M'z,48)    "is composite, a factor:"   r
      end   /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
isPrime: procedure; parse arg x; if wordpos(x,'2 3 5 7')\==0   then return 1
         if x<11  then return 0;          if x//2==0 | x//3    ==0 then return 0
              do j=5  by 6;               if x//j==0 | x//(j+2)==0 then return 0
              if j*j>x   then return 1
              end   /*j*/
/*────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;           do while q<=x;  q=q*4;  end
         do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end;end
       return r
/*────────────────────────────────────────────────────────────────────────────*/
modPow: procedure;  parse arg base,n,div;    sq=1;           $=x2b(d2x(n))+0
                       do  until $=='';      sq=sq**2
                       if left($,1)  then sq=sq*base//div;   $=substr($,2)
                       end   /*until ··· */
        return sq
/*────────────────────────────────────────────────────────────────────────────*/
testM:  procedure;  parse arg x               /*test a possible Mersenne prime*/
        sqRoot=iSqrt(2**x)                    /*iSqrt is:  integer square root*/
                                              /*─────      ─       ──  ─  ─   */
          do k=1;              q=2*k*x + 1    /*      _____                   */
          if q>sqRoot          then return 0  /*Is q>√(2^x)?  A Mersenne prime*/
          _=q // 8                            /*obtain the remainder when ÷ 8.*/
          if _\==1 & _\==7     then iterate   /*must be either  one  or  seven*/
          if \isPrime(q)       then iterate   /*Q ¬prime? Then keep on looking*/
          if modPow(2,x,q)==1  then return q  /*Not a prime?  Return a factor.*/
          end   /*k*/
