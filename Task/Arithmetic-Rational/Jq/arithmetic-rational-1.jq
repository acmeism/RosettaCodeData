# a and b are assumed to be non-zero integers
def gcd(a; b):
  # subfunction expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd: if .[1] == 0 then .[0]
         else [.[1], .[0] % .[1]] | rgcd
         end;
  [a,b] | rgcd;

# To take advantage of gojq's support for accurate integer division:
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# $p should be an integer or a rational
# $q should be a non-zero integer or a rational
# Output:  a Rational: $p // $q
def r($p;$q):
  def r: if type == "number" then {n: ., d: 1} else . end;
  # The remaining subfunctions assume all args are Rational
  def n: if .d < 0 then {n: -.n, d: -.d} else . end;
  def rdiv($a;$b):
    ($a.d * $b.n) as $denom
    | if $denom==0 then "r: division by 0" | error
    else r($a.n * $b.d; $denom)
    end;
  if $q == 1 and ($p|type) == "number" then {n: $p, d: 1}
  elif $q == 0 then "r: denominator cannot be 0" | error
  else if ($p|type == "number") and ($q|type == "number")
       then gcd($p;$q) as $g
       | {n: ($p/$g), d: ($q/$g)} | n
       else rdiv($p|r; $q|r)
       end
  end;

# Polymorphic (integers and rationals in general)
def requal($a; $b):
  if $a | type == "number" and $b | type == "number" then $a == $b
  else r($a;1) == r($b;1)
  end;

# Input: a Rational
# Output: a Rational with a denominator that has no more than $digits digits
# and such that |rBefore - rAfter| < 1/(10|power($digits)
# where $digits should be a positive integer.
def rround($digits):
  if .d | length > $digits
  then (10|power($digits)) as $p
  | .d as $d
  | r($p * .n | idivide($d); $p)
  else . end;

# Polymorphic; see also radd/0
def radd($a; $b):
  def r: if type == "number" then {n: ., d: 1} else . end;
    ($a|r) as {n: $na, d: $da}
  | ($b|r) as {n: $nb, d: $db}
  | r( ($na * $db) + ($nb * $da); $da * $db );

# Polymorphic; see also rmult/0
def rmult($a; $b):
  def r: if type == "number" then {n: ., d: 1} else . end;
    ($a|r) as {n: $na, d: $da}
  | ($b|r) as {n: $nb, d: $db}
  | r( $na * $nb; $da * $db ) ;

# Input: an array of rationals (integers and/or Rationals)
# Output: a Rational computed using left-associativity
def rmult:
  if length == 0 then r(1;1)
  elif length == 1 then r(.[0]; 1)  # ensure the result is Rational
  else .[0] as $first
  | reduce .[1:][] as $x ($first; rmult(.; $x))
  end;

# Input: an array of rationals (integers and/or Rationals)
# Output: a Rational computed using left-associativity
def radd:
  if length == 0 then r(0;1)
  elif length == 1 then r(.[0]; 1) # ensure the result is Rational
  else .[0] as $first
  | reduce .[1:][] as $x ($first; radd(. ; $x))
  end;

def rabs: r(.;1) | r(.n|length; .d|length);

def rminus: r(-1 * .n; .d);

def rminus($a; $b): radd($a; rmult(-1; $b));

# Note that rinv does not check for division by 0
def rinv: r(1; .);

def rdiv($a; $b): r($a; $b);

# Input: an integer or a Rational, $p
# Output: $p < $q
def rlessthan($q):
  # lt($b) assumes . and $b have the same sign
  def lt($b):
    . as $a
    | ($a.n * $b.d) < ($b.n * $a.d);

  if $q|type == "number" then rlessthan(r($q;1))
  else if type == "number" then r(.;1) else . end
  | if .n < 0
    then if ($q.n >= 0) then true
         else . as $p | ($q|rminus | rlessthan($p|rminus))
         end
    else lt($q)
    end
  end;

def rgreaterthan($q):
  . as $p | $q | rlessthan($p);

def rlessthanOrEqual($q): requal(.;$q) or rlessthan($q);
def rgreaterthanOrEqual($q): requal(.;$q) or rgreaterthan($q);

# Input: non-negative integer or Rational
def rsqrt(precision):
  r(.;1) as $n
  | (precision + 1) as $digits
  | def update: rmult( r(1;2); radd(.x; rdiv($n; .x))) | rround($digits);

  | def update: rmult( r(1;2); radd(.x; rdiv($n; .x)));

  r(1; 10|power(precision)) as $p
  | { x: .}
  | .root = update
  | until( rminus(.root; .x) | rabs | rlessthan($p);
      .x = .root
      | .root = update )
  | .root ;

# Use native floats
# q.v. r_to_decimal(precision)
def r_to_decimal: .n / .d;

# Input: a Rational, or {n, d} in general, or an integer.
# Output: a string representation of the input as a decimal number.
# If the input is a number, it is simply converted to a string.
# Otherwise, $precision determines the number of digits after the decimal point,
# obtained by truncating, but trailing 0s are omitted.
# Examples assuming $digits is 5:
#  -0//1 => "0"
#   2//1 => "2"
#   1//2 => "0.5"
#   1//3 => "0.33333"
#   7//9 => "0.77777"
#   1//100 => "0.01"
#  -1//10 => "-0.1"
#   1//1000000 => "0."
def r_to_decimal($digits):
  if .n == 0 # captures the annoying case of -0
  then "0"
  elif type == "number" then tostring
  elif .d < 0 then {n: -.n, d: -.d}|r_to_decimal($digits)
  elif .n < 0
  then "-" + ((.n = -.n) | r_to_decimal($digits))
  else (10|power($digits)) as $p
  | .d as $d
  | if $d == 1 then .n|tostring
    else ($p * .n | idivide($d) | tostring) as $n
    | ($n|length) as $nlength
    | (if $nlength > $digits then $n[0:$nlength-$digits] + "." + $n[$nlength-$digits:]
       else "0." + ("0"*($digits - $nlength) + $n)
       end) | sub("0+$";"")
    end
  end;

# Assume . is an integer or in canonical form
def rfloor:
  if type == "number" then r(.;1)
  elif 0 == .n or (0 < .n and .n < .d) then r(0;1)
  elif 0 < .n or (.n % .d == 0) then .d as $d | r(.n | idivide($d); 1)
  else rminus( r( - .n; .d) | rfloor | rminus; 1)
  end;

# pretty print ala Julia
def rpp: "\(.n) // \(.d)";
