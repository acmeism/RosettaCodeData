/*REXX program uses exponent-&-mod operator to test possible Mersenne #s*/
numeric digits 500                     /*we're dealing with some biggies*/

      do j=1  to 61;  z=j              /*when J=61, it turns into  929. */
      if z==61        then z=929       /*switcheroo,  61 turns into 929.*/
      if \isPrime(z)  then iterate     /*if not prime, keep plugging.   */
      r=testM(z)                       /*not, give it the 3rd degree.   */
      if r==0   then  say right('M'z,8)   "──────── is a Mersenne prime."
                else  say right('M'z,48)  "is composite, a factor:"    r
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MODPOW subroutine───────────────────*/
modPow: procedure;  parse arg base,n,div; sq=1
bits=x2b(d2x(n))+0                     /*dec──► hex──► binary, normalize*/
                    do  until bits=='';   sq=sq ** 2
                    if left(bits,1)  then sq=sq * base // div
                    bits=substr(bits,2)
                    end   /*until*/
return sq
/*─────────────────────────────────────ISPRIME subroutine───────────────*/
isPrime: procedure; parse arg x; if wordpos(x,'2 3 5 7')\==0   then return 1
if x<11 then return 0;   if x//2==0 then return 0; if x//3==0  then return 0
do j=5 by 6; if x//j==0|x//(j+2)==0 then return 0; if j*j>x then return 1;end
/*─────────────────────────────────────ISQRT subroutine─────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;    do while q<=x;  q=q*4; end
do while q>1; q=q%4;_=x-r-q;r=r%2;if _>=0 then do;x=_;r=r+q;end;end; return r
/*──────────────────────────────────TESTM subroutine────────────────────*/
testM: procedure;  parse arg x         /*test a possible Mersenne prime.*/
sqroot=iSqrt(2**x)                     /*iSqrt is:  integer square root.*/
                                       /*─────      ─       ──  ─  ─    */
  do k=1;              q=2*k*x + 1     /*       _____                   */
  if q>sqroot          then leave      /*Is  q>√(2^x) ?  Then we're done*/
  _=q // 8                             /*perform modulus arithmetic.    */
  if _\==1 & _\==7     then iterate    /*must be either one or seven.   */
  if \isPrime(q)       then iterate    /*if not prime, keep on trukin'. */
  if modPow(2,x,q)==1  then return q   /*Not a prime?   Return a factor.*/
  end   /*k*/

return 0                               /*it's a Mersenne prime, by gum. */
