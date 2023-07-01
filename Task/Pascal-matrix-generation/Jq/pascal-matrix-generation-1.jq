# Generic functions

# Note: 'transpose' is defined in recent versions of jq
def transpose:
  if (.[0] | length) == 0 then []
  else [map(.[0])] + (map(.[1:]) | transpose)
  end ;

# Create an m x n matrix with init as the initial value
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [range(0;n) | init]
  elif m > 0 then
    matrix(1;n;init) as $row
    | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end ;

# A simple pretty-printer for a 2-d matrix
def pp:
  def pad(n): tostring | (n - length) * " " + .;
  def row: reduce .[] as $x (""; . + ($x|pad(4)));
  reduce .[] as $row (""; . + "\n\($row|row)");
