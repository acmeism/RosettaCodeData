def sum(s): reduce s as $_ (0; . + $_);

# Sum of squares
def ss(s): sum(s|.*.);

# Create an m x n matrix
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [range(0;n) | init]
  elif m > 0 then
    matrix(1;n;init) as $row
    | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end;

def dot_product(a; b):
  reduce range(0;a|length) as $i (0; . + (a[$i] * b[$i]) );

# A and B should both be numeric matrices, A being m by n, and B being n by p.
def multiply($A; $B):
  ($B[0]|length) as $p
  | ($B|transpose) as $BT
  | reduce range(0; $A|length) as $i
       ([];
       reduce range(0; $p) as $j
         (.;
          .[$i][$j] = dot_product( $A[$i]; $BT[$j] ) ));

# $ndec decimal places
def round($ndec):
  def rpad: tostring | ($ndec - length) as $l | . + ("0" * $l);
  def abs: if . < 0 then -. else . end;
  pow(10; $ndec) as $p
  | round as $round
  | if $p * ((. - $round)|abs) < 0.1
    then ($round|tostring)  + "." + ($ndec * "0")
    else  . * $p | round / $p
    | tostring
    | capture("(?<left>[^.]*)[.](?<right>.*)")
    | .left + "." + (.right|rpad)
    end;

# pretty-print a 2-d matrix
def pp($ndec; $width):
  def pad(n): tostring | (n - length) * " " + .;
  def row: map(round($ndec) | pad($width)) | join(" ");
  reduce .[] as $row (""; . + "\n\($row|row)");
