/*REXX program calculates the gamma function using Spouge's approximation with 87 digits*/
e=2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138
numeric digits length(e)   -  length(.)          /*use the number of decimal digits in E*/
c.=  0
# = 40                                           /*#:  the number of steps in GAMMA func*/
                    call sq gamma(-3/2),  3/4
                    call sq gamma(-1/2), -1/2
                    call sq gamma( 1/2),   1
                    call si gamma(  1 )
                    call sq gamma( 3/2),   2
                    call si gamma(  2 )
                    call sq gamma( 5/2),  4/3
                    call si gamma(  3 )
                    call sq gamma( 7/2),  8/15
                    call si gamma(  4 )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gamma: procedure expose c. e #; parse arg z;         #p= # + 1
       accm = c.1
       if accm==0  then do;  accm= sqrt( 2*pi() )
                             c.1 = accm
                             kfact = 1
                                         do k=2  to #
                                         c.k= exp(#p-k) * pow(#p-k, k-1.5) / kfact
                                         kfact = kfact  *  -(k-1)
                                         end   /*k*/
                        end

           do j=2  to #;   accm = accm   +   c.j / (z+j-1)
           end   /*k*/

       return (accm * exp(-(z+#)) * pow(z+#, z+0.5) ) / z
/*──────────────────────────────────────────────────────────────────────────────────────*/
pi: return 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348
fmt:    parse arg n,p,a;  _= format(n,p,a);  L= length(_);      return left( strip0(_), L)
isInt:  return datatype(arg(1), 'W')                      /*is the argument an integer? */
sq:     procedure expose #; parse arg x,mu; say fmt(x,9,#)  fmt((x*mu)**2,9,#);   return
si:     procedure expose #; parse arg x;    say fmt(x,9,#);                       return
strip0: procedure; arg _; if pos(., _)\==0  then _= strip(strip(_,'T',0),'T',.);  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
exp: procedure expose e; arg x; ix= x%1; if abs(x-ix)>.5  then ix=ix+sign(x); x= x-ix; z=1
     _=1;  w=1;    do j=1;  _= _*x/j;    z= (z+_)/1;      if z==w  then leave;         w=z
                   end  /*j*/;           if z\==0  then z= e**ix * z;             return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
ln:     procedure; parse arg x; call e; ig= x>1.5; is= 1-2*(ig\==1); ii= 0; xx= x
          do while ig & xx>1.5 | \ig & xx<.5; _=e
        do k=-1; iz=xx*_**-is; if k>=0&(ig&iz<1|\ig&iz>.5)  then leave; _=_*_; izz=iz; end
        xx= izz; ii= ii+is*2**k;   end   /*while*/;      x= x*e**-ii-1;  z=0;  _= -1;  p=z
          do k=1; _=-_*x;  z=z+_/k;  if z=p  then leave;  p=z; end;  /*k*/;    return z+ii
/*──────────────────────────────────────────────────────────────────────────────────────*/
pow:    procedure; parse arg x,y;  if y=0  then return 1;  if x=0  then return 0
        if isInt(y)  then return x**y;          if isInt(1/y)  then return root(x, 1/y)
        if abs(y//1)=.5  then return sqrt(x)**sign(y)*x**(y%1);     return exp( y*ln(x) )
/*──────────────────────────────────────────────────────────────────────────────────────*/
root:   procedure; parse arg x 1 ox,y 1 oy;     if x=0 | y=1  then return x/1
        if \isInt(y)  then return $pow(x, 1/y)
        if y==2  then return sqrt(x); if y==-2  then return 1/sqrt(x); return rooti(x,y)/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
rooti:  x=abs(x); y=abs(y); a= digits() + 5;  m= y-1;  d= 5
        parse value format(x,2,1,,0) 'E0'  with  ? 'E' _ .;   g= (?/y'E'_ % y) + (x>1)
          do until d==a;   d=min(d+d, a);  numeric digits d;  o=0
            do until o=g;  o=g;  g= format((m*g**y+x)/y/g**m,,d-2);  end;  end
        _= g*sign(ox);  if oy<0  then _= 1/_;                                     return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  numeric digits;  h=d+6
      numeric form; m.=9; parse value format(x,2,1,,0) 'E0' with g "E" _ .; g=g *.5'e'_ %2
            do j=0  while h>9;        m.j=h;                 h=h%2+1;          end  /*j*/
            do k=j+5  to 0  by -1;    numeric digits m.k;    g=(g+x/g)*.5;     end  /*k*/
      numeric digits d;     return g/1
