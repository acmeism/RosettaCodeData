# Complex numbers as points [x,y] in the Cartesian plane
def real(z): if (z|type) == "number" then z else z[0] end;

def imag(z): if (z|type) == "number" then 0 else z[1] end;

def plus(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x+y, 0 ]
       else [ x + y[0], y[1]]
       end
    elif (y|type) == "number" then plus(y;x)
    else [ x[0] + y[0], x[1] + y[1] ]
    end;

def multiply(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x*y, 0 ]
       else [x * y[0], x * y[1]]
       end
    elif (y|type) == "number" then multiply(y;x)
    else [ x[0] * y[0] - x[1] * y[1],  x[0] * y[1] + x[1] * y[0]]
    end;

def negate(x): multiply(-1; x);

def minus(x; y): plus(x; multiply(-1; y));

def conjugate(z):
  if (z|type) == "number" then [z, 0]
  else  [z[0], -(z[1]) ]
  end;

def invert(z):
  if (z|type) == "number" then [1/z, 0]
  else
    ( (z[0] * z[0]) + (z[1] * z[1]) ) as $d
   # use "0 + ." to convert -0 back to 0
    | [ z[0]/$d, (0 + -(z[1]) / $d)]
  end;

def divide(x;y): multiply(x; invert(y));

def magnitude(z):
  real( multiply(z; conjugate(z))) | sqrt;

# exp^z
def complex_exp(z):
  def expi(x): [ (x|cos), (x|sin) ];
  if (z|type) == "number" then z|exp
  elif z[0] == 0 then expi(z[1])  # for efficiency
  else multiply( (z[0]|exp); expi(z[1]) )
  end ;

def complex_sqrt(z):
  if imag(z) == 0 and real(z) >= 0 then [(real(z)|sqrt), 0]
  else
    magnitude(z) as $r
    | if $r == 0 then [0,0]
      else
      (real(z)/$r) as $a
      | (imag(z)/$r) as $b
      | $r | sqrt as $r
      | (($a | acos) / 2)
      | [ ($r * cos), ($r * sin)]
      end
  end ;
