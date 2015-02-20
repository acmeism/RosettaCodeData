/*REXX program displays some non─square numbers (with validation check).*/
          do j=1  for 22
          say  right(j,6)  right(j+floor(1/2 + sqrt(j)),7)
          end   /*j*/
oops=0
          do k=1  for 1000000-1
          n=k+floor(.5+sqrt(k))
          iroot=isqrt(n)
          if iroot*iroot==n  then oops=oops+1
          end   /*k*/
say
say oops  'squares found up to'  k-1
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FLOOR subroutine────────────────────*/
floor: procedure; parse arg x; return trunc(x- (x<0) )
/*──────────────────────────────────ISQRT subroutine────────────────────*/
isqrt: procedure; parse arg x; x=trunc(x); r=0; q=1
  do while q<=x; q=q*4; end
  do while q>1;  q=q%4; _=x-r-q; r=r%2; if _>=0 then do; x=_;r=r+q;end;end
return r                       /*return the integer square root of X.   */
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure; parse arg x,f;     if x=0  then return 0;    d=digits()
numeric digits 11;  g=x/4;  m.=11;  p=d+d%4+2
  do j=0  while  p>9;  m.j=p;       p=p%2+1;  end
  do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k;g=.5*(g+x/g); end
numeric digits d
return g/1                     /*return the normalized square root of X.*/
