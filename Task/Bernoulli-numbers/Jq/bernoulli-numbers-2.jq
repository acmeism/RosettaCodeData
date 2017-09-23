# A fraction is represented by [numerator, denominator] in reduced form, with the sign on top

# a and b should be BigInt; return a BigInt
def gcd(a; b):
  def long_abs: . as $in | if lessOrEqual("0"; $in) then $in else negate end;

  # subfunction rgcd expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd:
    .[0] as $a | .[1] as $b
    | if $b == "0" then $a
      else [$b, long_mod($a ; $b ) ] | rgcd
      end;

  a as $a | b as $b
  | [$a,$b] | rgcd | long_abs ;

def normalize:
  .[0] as $p | .[1] as $q
  | if $p == "0" then ["0", "1"]
    elif lessOrEqual($q ; "0") then [ ($p|negate), ($q|negate)] | normalize
    else gcd($p; $q) as $g
    | [ long_div($p;$g), long_div($q;$g) ]
    end ;

# a and b should be fractions expressed in the form [p, q]
def add(a; b):
  a as $a | b as $b
  | if $a[1] == "1" and $b[1] == "1" then [ long_add($a[0]; $b[0]) , "1"]
    elif $a[1] == $b[1] then [ long_add( $a[0]; $b[0]), $a[1] ] | normalize
    elif $a[0] == "0" then $b
    elif $b[0] == "0" then $a
    else [ long_add( long_multiply($a[0]; $b[1]) ; long_multiply($b[0]; $a[1])),
           long_multiply($a[1]; $b[1]) ]
    | normalize
    end ;

# a and/or b may be BigInts, or [p,q] fractions
def multiply(a; b):
  a as $a | b as $b
  | if ($a|type) == "string" and ($b|type) == "string" then [ long_multiply($a; $b), "1"]
    else
      if $a|type == "string" then [ long_multiply( $a; $b[0]), $b[1] ]
      elif $b|type == "string" then [ long_multiply( $b; $a[0]), $a[1] ]
      else  [ long_multiply( $a[0]; $b[0]), long_multiply($a[1]; $b[1]) ]
      end
      | normalize
  end ;

def minus(a; b):
  a as $a | b as $b
  | if $a == $b then ["0", "1"]
    else add($a; [ ($b[0]|negate), $b[1] ] )
    end ;
