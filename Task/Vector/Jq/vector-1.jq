def polar(r; angle):
  [ r*(angle|cos), r*(angle|sin) ];

# If your jq allows multi-arity functions, you may wish to uncomment the following line:
# def polar(r): [r, 0];

def polar2vector: polar(.[0]; .[1]);

def vector(x; y):
  if (x|type) == "number" and (y|type) == "number" then [x,y]
  else error("TypeError")
  end;

# Input: an array of same-dimensional vectors of any dimension to be added
def sum:
  def sum2: .[0] as $a | .[1] as $b | reduce range(0;$a|length) as $i ($a; .[$i] += $b[$i]);
  if length <= 1 then .
  else reduce .[1:][] as $v (.[0] ; [., $v]|sum2)
  end;

def multiply(scalar): [ .[] * scalar ];

def negate: multiply(-1);

def minus(v): [., (v|negate)] | sum;

def divide(scalar):
  if scalar == 0 then error("division of a vector by 0 is not supported")
  else [ .[] / scalar ]
  end;

def r: (.[0] | .*.) + (.[1] | .*.) | sqrt;

def atan2:
  def pi: 1 | atan * 4;
  def sign: if . < 0 then -1 elif . > 0 then 1 else 0 end;
  .[0] as $x | .[1] as $y
  | if $x == 0 then $y | sign * pi / 2
    else  ($y / $x) | if $x > 0 then atan elif . > 0 then atan - pi else atan + pi end
    end;

def angle: atan2;

def topolar: [r, angle];
