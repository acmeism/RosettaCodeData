/*REXX pgm gens 1,000 normally distributed #s:  mean=1, standard dev.=½.*/
numeric digits 20                      /*greater precision than 9 digits*/
parse arg n seed .                     /*allow specification of N & seed*/
if n==''  |  n==','  then n=1000       /*N:    is the size of the array.*/
if seed\==''  then call random ,,seed  /*SEED: for repeatable random #'s*/
newMean=1                              /*desired new mean|arithmetic avg*/
sd=1/2                                 /*desired new standard deviation.*/
       do g=1  for n                   /*gen N uniform random #'s (0,1].*/
       #.g = random(1,1e5) / 1e5       /*RANDOM  bif generates integers.*/
       end   /*g*/                     /* [↑]  rand integers──►fractions*/
say '              old mean=' mean()
say 'old standard deviation=' stddev()
call pi;       pi2=pi+pi               /*define   pi   and also   2*pi. */
say
       do j=1  to n-1  by 2;   m=j+1   /*step through iterations by two.*/
           _=sd *  sqrt(ln(#.j) * -2)  /*calculate used-twice expression*/
       #.j=_ * cos(pi2*#.m)  + newMean /*utilize the  Box─Muller method.*/
       #.m=_ * sin(pi2*#.m)  + newMean /*random number must be:   (0,1] */
       end   /*j*/
say '              new mean=' mean()
say 'new standard deviation=' stddev()
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines──────────────────────────────────────────────────────────────────────*/
mean:   _=0;                do k=1  for n;  _=_+#.k;           end;                        return      _/n
stddev: _avg=mean(); _=0;   do k=1  for n;  _=_+(#.k-_avg)**2; end;                        return sqrt(_/n)
e:      e =2.7182818284590452353602874713526624977572470936999595749669676277240766303535; return e   /*digs overkill*/
pi:     pi=3.1415926535897932384626433832795028841971693993751058209749445923078164062862; return pi  /*  "      "   */
r2r:    return arg(1) // (2*pi())                                                                     /*normalize ang*/
sqrt:   procedure; parse arg x; if x=0  then return 0;  d=digits(); numeric digits 11; numeric form;  m.=11;  p=d+d%4+2
        parse value format(x,2,1,,0) 'E0' with g 'E' _ .;  g=g*.5'E'_%2;      do j=0  while p>9;  m.j=p;  p=p%2+1;  end
         do k=j+5  to 0  by -1; if m.k>11  then numeric digits m.k; g=.5*(g+x/g); end;    numeric digits d;  return g/1
cos:    procedure; parse arg x; x=r2r(x); a=abs(x); numeric fuzz min(9,digits()-9); if a=pi  then return -1;  pi2=pi+pi
        if a=pi*.5|a=pi2  then return 0; if a=pi/3  then return .5; if a=pi2/3  then return -.5; return .sincos(1,1,-1)
sin:    procedure; parse arg x;x=r2r(x);numeric fuzz min(5,digits()-3);if abs(x)=pi then return 0;return .sincos(x,x,1)
.sincos:parse arg z,_,i; x=x*x; p=z;    do k=2 by 2; _=-_*x/(k*(k+i)); z=z+_; if z=p then leave; p=z; end;     return z
ln:     procedure; parse arg x,f;   call e;   ig= x>1.5;    is=1-2*(ig\==1);   ii=0;   xx=x;     return .ln_comp()
.ln_comp: do while ig&xx>1.5|\ig&xx<.5;_=e;do k=-1;iz=xx*_**-is;if k>=0&(ig&iz<1|\ig&iz>.5) then leave;_=_*_;izz=iz;end
        xx=izz;ii=ii+is*2**k;end;x=x*e**-ii-1;z=0;_=-1;p=z;do k=1;_=-_*x;z=z+_/k;if z=p then leave;p=z;end; return z+ii
