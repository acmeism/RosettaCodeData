## Generic matrix functions

# Create an m x n matrix
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [range(0;n) | init]
  elif m > 0 then
    matrix(1;n;init) as $row
    | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end;

# Input: a numeric array
def signChanges:
  def s: if . > 0 then 1 elif . < 0 then -1 else 0 end;
  . as $row
  | reduce range(1;length) as $i (0;
     if ($row[$i-1]|s) == -($row[$i]|s) then . + 1 else . end );

# Print a matrix of integers
# $width is the minimum width to use per cell
def mprint($width):
   def max(s): reduce s as $x (null; if . == null or $x > . then $x else . end);
   def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

   (max($width, (.[][] | tostring | length) + 1)) as $w
   | . as $in
   | range(0; length) as $i
   | reduce range(0; .[$i]|length) as $j ("|"; . + ($in[$i][$j]|lpad($w)))
   | . + " |" ;

def cprint:
  . as $in
  | range(0; length) as $i
  | reduce range(0; .[$i]|length) as $j (""; . + ($in[$i][$j]));

def color: if . == 1 then "🟥" else "🟩" end;
