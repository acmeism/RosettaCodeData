/*REXX program displays some  non─square numbers  (with a validation check).  */
          do j=1  for 22
          say  right(j, 6)  right(j + floor(1/2 + sqrt(j)), 7)
          end   /*j*/
oops=0
          do k=1  for 1000000-1
          n=k+floor(.5+sqrt(k))
          iroot=isqrt(n)
          if iroot*iroot==n  then oops=oops+1
          end   /*k*/
say
say oops   'squares found up to'   k-1
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
floor: procedure; parse arg x; return trunc(x- (x<0) )
/*────────────────────────────────────────────────────────────────────────────*/
isqrt: procedure; parse arg x; x=trunc(x); r=0; q=1
         do while q<=x; q=q*4; end
         do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do; x=_;r=r+q;end;end
       return r                        /*return the integer square root of  X.*/
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
