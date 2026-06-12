def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def rpad($len): tostring | ($len - length) as $l | .+ ("0" * $l)[:$l];

# Input: a non-negative number or a string representation of a non-negative number.
# Output: if tostring has no "e" or "E", adjust the number of
# decimal digits to be $n, otherwise adjust $n to allow room for the exponent.
def align_decimal($n):
  tostring
  | if test("e|E")
    then capture( "^(?<x>[^eE]*)[eE](?<e>.*)$" )
    | (.e | length + 1) as $e
    | (.x | align_decimal($n - $e)) + "e" + .e
    elif index(".")
    then capture("(?<i>[0-9]*[.])(?<j>[0-9]{0," + ($n|tostring) + "})")
    | .i + (.j|rpad($n))
    else . + "." + ("0" * $n)
    end ;

def Vector3D($x; $y; $z):
  {$x, $y, $z};

def Vector3D_add($v):
    .x += $v.x | .y += $v.y | .z += $v.z;

def Vector3D_add:
  . as $in
  | reduce range(1; length) as $i (.[0]; Vector3D_add($in[$i])) ;

# $a - $v
def Vector3D_minus($a; $v):
  $a
  | .x -= $v.x | .y -= $v.y | .z -= $v.z ;

# $v should be a number
def Vector3D_mult($v):
    .x *= $v   | .y *= $v   | .z *= $v ;

# input: Vector3D
def norm:  # i.e. mod
  (.x * .x + .y * .y + .z * .z) | sqrt;

def Origin: Vector3D(0; 0; 0);

# input: a string representing three numbers
# aka decompose
def toVector3D:
  [splits("  *") | tonumber]
  | Vector3D(.[0]; .[1]; .[2]);
