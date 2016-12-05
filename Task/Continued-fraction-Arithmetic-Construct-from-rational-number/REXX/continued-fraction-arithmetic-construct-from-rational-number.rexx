/*REXX program converts a  decimal  or  rational fraction  to a  continued fraction.    */
numeric digits 230                               /*determines how many terms to be gened*/
say '              1/2  ──► CF: '   r2cf( '1/2'   )
say '               3   ──► CF: '   r2cf(   3     )
say '             23/8  ──► CF: '   r2cf( '23/8'  )
say '             13/11 ──► CF: '   r2cf( '13/11' )
say '             22/7  ──► CF: '   r2cf( '22/7 ' )
say '                       ___'
say '───────── attempts at √ 2.'
say '14142/1e4          ──► CF: '   r2cf( '14142/1e4 ' )
say '141421/1e5         ──► CF: '   r2cf( '141421/1e5 ' )
say '1414214/1e6        ──► CF: '   r2cf( '1414214/1e6 ' )
say '14142136/1e7       ──► CF: '   r2cf( '14142136/1e7 ' )
say '141421356/1e8      ──► CF: '   r2cf( '141421356/1e8 ' )
say '1414213562/1e9     ──► CF: '   r2cf( '1414213562/1e9 ' )
say '14142135624/1e10   ──► CF: '   r2cf( '14142135624/1e10 ' )
say '141421356237/1e11  ──► CF: '   r2cf( '141421356237/1e11 ' )
say '1414213562373/1e12 ──► CF: '   r2cf( '1414213562373/1e12 ' )
say '√2                 ──► CF: '   r2cf(  sqrt(2)  )
say
say '───────── an attempt at pi'
say 'pi                 ──► CF: '   r2cf(  pi() )
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
r2cf: procedure; parse arg g 1 s 2;  $=;   if s=='-'  then g = substr(g,2)
                                                      else s =
      if pos('.',g)\==0 then do
                             if \datatype(g,'N') then call serr 'not numeric:' g
                             g = $maxfact(g)
                             end
      if pos('/',g)==0  then g = g"/"1
      parse var g n '/' d
      if \datatype(n,'W')  then call serr   "a numerator isn't an integer:"  n
      if \datatype(d,'W')  then call serr "a denominator isn't an integer:"  d
      n = abs(n)                                       /*ensure numerator is positive.  */
      if d=0               then call serr 'a denominator is zero'

                       do  while  d\==0                /*where the rubber meets the road*/
                       $ = $    s || (n%d)             /*append another number to list. */
                       _ = d
                       d = n // d                      /* %  is int div,  // is modulus.*/
                       n = _
                       end   /*while*/
      return strip($)
/*──────────────────────────────────────────────────────────────────────────────────────*/
pi: return 3.1415926535897932384626433832795028841971693993751058209749445923078164062862,
           || 089986280348253421170679821480865132823066470938446095505822317253594081284,
           || 811174502841027019385211055596446229489549303819644288109756659334461284756,
           || 48233786783165271              /* ··· should  ≥  NUMERIC DIGITS */
/*──────────────────────────────────────────────────────────────────────────────────────*/
serr: say;    say '***error!***';    say;    say arg(1);     say;    exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();   h=d+6;   numeric form
      m.=9; numeric digits; parse value format(x,2,1,,0) 'E0' with g 'E' _ .; g=g*.5'e'_%2
                     do j=0  while h>9;      m.j=h;               h=h%2+1;       end /*j*/
                     do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end /*k*/
      numeric digits d;     return g/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
$maxFact: procedure;  parse arg x 1 _x,y;   y=10**(digits()-1);  b=0;  h=1;  a=1;  g=0
            do while a<=y & g<=y;  n=trunc(_x);  _=a;  a=n*a+b;  b=_;  _=g;  g=n*g+h;  h=_
            if n=_x | a/g=x  then do; if a>y|g>y  then iterate; b=a; h=g; leave; end
            _x=1/(_x-n);  end;                                               return  b'/'h
