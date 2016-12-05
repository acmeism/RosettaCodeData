/*REXX program  calculates  the  distance between  Nashville  and  Los Angles  airports.*/
call pi;  numeric digits length(pi)%2            /*use half of decimal digits  of  PI.  */
say "       Nashville:  north 36º  7.2', west  86º 40.2'   =   36.12º,  -86.67º"
say "      Los Angles:  north 33º 56.4', west 118º 24.0'   =   33.94º, -118.40º"
@using_radius= 'using the mean radius of the earth as '            /*a literal for  SAY.*/
radii.=.;    radii.1=6372.8;    radii.2=6371     /*mean radii of the earth in kilometers*/
say;                         m=1/0.621371192237  /*M:   one statute mile  in      "     */
    do radius=1 while radii.radius\==.           /*calc. distance using specific radius.*/
    d=surfaceDistance( 36.12,    -86.67,    33.94,   -118.4,    radii.radius);         say
    say center(@using_radius     radii.radius         ' kilometers', 75, '─')
    say ' Distance between:  '   format(d/1            ,,2)    " kilometers,"
    say '               or   '   format(d/m            ,,2)    " statute miles,"
    say '               or   '   format(d/m*5280/6076.1,,2)    " nautical (or air miles)."
    end   /*radius*/                             /*these └───◄  displays 2 decimal digs.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Acos: return .5*pi() - aSin( arg(1) )
d2d:  return arg(1)         //  360              /*normalize degrees to a  unit circle. */
d2r:  return r2r(arg(1)*pi() /  180)             /*normalize and convert deg ──► radians*/
r2d:  return d2d((arg(1)*180 /  pi()))           /*normalize and convert rad ──► degrees*/
r2r:  return arg(1)         // (pi()*2)          /*normalize radians to a  unit circle. */
p:    return word(arg(1),1)                      /*pick the first of two words (numbers)*/
pi:   pi=3.141592653589793238462643383279502884197169399375105820975;            return pi
/*──────────────────────────────────────────────────────────────────────────────────────*/
surfaceDistance: parse arg th1,ph1,th2,ph2,r     /*use  haversine  formula for distance.*/
          numeric digits digits() * 2            /*double the number of decimal digits. */
             ph1= d2r(ph1 - ph2)                 /*convert degrees ──► radians & reduce.*/
             th1= d2r(th1);      th2 =  d2r(th2) /*   "       "     "     "    "    "   */
               x= cos(ph1) * cos(th1) - cos(th2)
               y= sin(ph1) * cos(th1)
               z= sin(th1) - sin(th2)
          return Asin( sqrt( x**2 + y**2 + z**2)  / 2 )    *  r  *  2
/*──────────────────────────────────────────────────────────────────────────────────────*/
Asin: procedure; parse arg x 1 z 1 o 1 p;    a=abs(x);        aa=a*a
          if a>=sqrt(2) * .5  then  return sign(x) * Acos(sqrt(1-aa))
                    do j=2  by 2  until p=z;  p=z; o=o*aa*(j-1)/j; z=z+o/(j+1);  end /*j*/
          return  z                              /* [↑]  compute until no more noise.   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos:  procedure; parse arg x;       x=r2r(x);      a=abs(x);         Hpi=pi*.5
          numeric fuzz min(6,digits()-3);          if a=pi()    then return -1
          if a=Hpi | a=Hpi*3  then return 0;       if a=pi()/3  then return .5
          if a=pi()*2/3  then return -.5;                           return .sinCos(1,1,-1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sin:  procedure; parse arg x;  x=r2r(x);           numeric fuzz  min(5, digits()-3)
         if abs(x)=pi()  then return 0;                              return .sinCos(x,x,1)
/*──────────────────────────────────────────────────────────────────────────────────────*/
.sinCos: parse arg z 1 p,_,i;  q=x*x
            do k=2  by 2; _=-_*q/(k*(k+i)); z=z+_; if z=p  then leave; p=z; end;  return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits;  parse value format(x,2,1,,0) 'E0' with g "E" _ .;  g=g * .5'e'_ % 2
                     do j=0  while h>9;      m.j=h;               h=h%2+1;       end /*j*/
                     do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end /*k*/
