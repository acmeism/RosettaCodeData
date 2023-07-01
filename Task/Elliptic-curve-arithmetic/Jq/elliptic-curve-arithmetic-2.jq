def Pt(x;y): [x, y];

def isPt: type == "array" and length == 2 and (map(type)|unique) == ["number"];

def zero: Pt(infinite; infinite);

def isZero: .[0] | (isinfinite or . == 0);

def C: 7;

def fromNum: Pt((.*. - C)|cbrt; .) ;

def double:
  if isZero then .
  else . as [$x,$y]
  | ((3 * ($x * $x)) / (2 * .[1])) as $l
  | ($l*$l - 2*$x) as $t
  | Pt($t; $l*($x - $t) - $y)
  end;

def minus: .[1] *= -1;

def plus($other):
  if ($other|isPt|not) then "Argument of plus(Pt) must be a Pt object but got \(.)." | error
  elif (.[0] == $other[0] and .[1] == $other[1]) then double
  elif isZero then $other
  elif ($other|isZero) then .
  else . as [$x, $y]
  | (if $other[0] == $x then infinite
    else (($other[1] - $y) / ($other[0] - $x)) end) as $l
  | ($l*$l - $x - $other[0]) as $t
  | Pt($t; $l*($x-$t) - $y)
  end;

def plus($a; $b): $a | plus($b);

def mult($n):
  if ($n|type) != "number" or ($n | ( . != floor))
  then  "Argument must be an integer, not \($n)." | error
  else { r: zero,
         p: .,
         i: 1 }
  | until (.i > $n;
      if bitwise_and_nonzero(.i; $n) then .r = plus(.r;.p) else . end
      | .p |= double
      | .i *= 2 )
  | .r
  end;

def toString:
  if isZero then "Zero"
  else map(round(3))
  end;


def a: 1|fromNum;
def b: 2|fromNum;
def c: plus(a; b);
def d: c | minus;

def task:
  "a         = \(a|toString)",
  "b         = \(b|toString)",
  "c = a + b = \(c|toString)",
  "d = -c    = \(d|toString)",
  "c + d     = \(plus(c; d)|toString)",
  "(a+b) + d = \(plus(plus(a; b);d)|toString)",
  "a * 12345 = \(a | mult(12345) | toString)"
;

task
