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
    else [ x[0] * y[0] - x[1] * y[1],
           x[0] * y[1] + x[1] * y[0]]
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

def exp(z):
  def expi(x): [ (x|cos), (x|sin) ];
  if (z|type) == "number" then z|exp
  elif z[0] == 0 then expi(z[1])  # for efficiency
  else multiply( (z[0]|exp); expi(z[1]) )
  end ;

def test(x;y):
  "x =      \( x )",
  "y =      \( y )",
  "x+y:     \( plus(x;y))",
  "x*y:     \( multiply(x;y))",
  "-x:      \( negate(x))",
  "1/x:     \( invert(x))",
  "conj(x): \( conjugate(x))",
  "(x/y)*y: \( multiply( divide(x;y) ; y) )",
  "e^iπ:    \( exp( [0, 4 * (1|atan)  ] ) )"
;

test( [1,1]; [0,1] )
