# Part 1: Library functions

### Counting and integer arithmetic

def count(s): reduce s as $x (0; .+1);

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  (. - (. % $j)) / $j ;

def idivide($i; $j):
  $i | idivide($j);

# Emit [dividend, mod]
def divmod($j):
  (. % $j) as $mod
  | [(. - $mod) / $j, $mod] ;

# input should be a non-negative integer for accuracy
# but may be any non-negative finite number
def isqrt:
  def irt:
    . as $x
    | 1 | until(. > $x; . * 4) as $q
    | {$q, $x, r: 0}
    | until( .q <= 1;
        .q |= idivide(4)
        | .t = .x - .r - .q
        | .r |= idivide(2)
        | if .t >= 0
          then .x = .t
          | .r += .q
          else .
          end)
    | .r ;
  if type == "number" and (isinfinite|not) and (isnan|not) and . >= 0
  then irt
  else "isqrt requires a non-negative integer for accuracy" | error
  end ;

# It is assumed that $n >= 0
def power($n):
  . as $in
  | reduce range(0;$n) as $i (1; .* $in);

# For syntactic convenience
def power($in; $n): $in | power($n);

def gcd(a; b):
  # subfunction expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd: if .[1] == 0 then .[0]
         else [.[1], .[0] % .[1]] | rgcd
         end;
  [a,b] | rgcd;


### Bit arrays and streams

def rightshift($n):
  reduce range(0;$n) as $i (.; idivide(2));

# Convert the input integer to a stream of 0s and 1s, least significant bit first
def bitwise:
  recurse( if . >= 2 then idivide(2) else empty end) | . % 2;

def bitLength: count(bitwise);

def firstBit:
  if . == 0 then empty
  else first( foreach bitwise as $b (-1; .+1; if $b == 1 then . else empty end))
  end;

# Return true if the $i-th least-significant bit is 1, and false otherwise
def testBit($i):
  (nth($i; bitwise) // 0) == 1;

# Part 2: "modulo" functions

# The multiplicative inverse of . modulo $n
def modInv($n):
  . as $in
  | { r: $n,
      newR: length, # abs
      t: 0,
      newT: 1 }
  | until (.newR != 0.;
      idivide(.r; .newR) as $q
      | .lastT = .t
      | .lastR = .r
      | .t = .newT
      | .r = .newR
      | .newT = .lastT - $q*.newT
      | .newR = .lastR - $q*.newR )
  | if .r != 1
    then "\($in) and \($n) are not co-prime." | error
    else if (.t < 0) then .t += $n end
    | if ($in < 0) then - .t else .t end
    end;

# Return . to the power $exp modulo $mod
def modPow($exp; $mod):
  def isOdd: . % 2 == 1;
  if $mod == 0 then "Cannot take modPow with modulus 0." | error
  else {r: 1, base: (. % $mod), $exp}
  | if .exp < 0
    then .exp *= -1
    | .base |= modInv($mod)
    end
 |  until ((.exp == 0) or .emit;
       if .base == 0 then .emit = 0
       else if (.exp | isOdd) then .r = (.r * .base) % $mod end
       | .exp |= idivide(2)
       | .base |= (.*.) % $mod
       end )
  | (.emit // .r)
  end ;

# Part 3: Multiplicative order

def moBachShallit58($a; $n; $pf):
  {n1: ($n - 1),
   mo: 1 }
  | reduce $pf[] as $pe (.;
        (.n1 | idivide($pe.prime | power($pe.exp))) as $y
        | .o = 0
        | .x = ($a | modPow($y; ($n|length)))
        | until (.x <= 1;
            .x |= modPow($pe.prime; ($n|length) )
            | .o += 1 )
        | .o1 = .o
        | .o1 = power($pe.prime;.o1)
        | .o1 = idivide(.o1; gcd(.mo; .o1) )
        | .mo = .mo * .o1 )
  | .mo ;

def factor($n):
  { pf: [],
    nn: $n,
    e:  ($n | firstBit)}
  | if .e > 0
    then .e as $e
    | .nn |= rightshift($e)
    | .pf = [{prime: 2, exp: .e}]
    end
  | (.nn | isqrt) as $s
  | .d = 3
  | until (.nn <= 1;
      if .d > $s then .d = .nn end
      | .e = 0
      | .done = null
      | until( .done;
           .d as $d
           | (.nn | divmod($d)) as $dm
           | if $dm[1] > 0
             then .done = true
             else .nn = $dm[0]
             | .e += 1
             end )
     | if .e > 0
       then .pf += [{prime: .d, exp: .e}]
       |.s = (.nn|isqrt)
       end
     | .d += 2
   )
  | .pf ;

# $n should be prime
def moTest($a; $n):
    if ($a|bitLength) < 100 then "ord(\($a)) " else "ord([big]) " end +
    if ($n|bitLength) < 100 then "mod \($n) " else "mod [big] " end +
    "= \(moBachShallit58($a; $n; factor($n - 1)))" ;

moTest(37; 3343),
moTest(1 + power(10;100); 7919),
moTest(1 + power(10;100); 15485863),
moTest(power(10;10000) - 1; 22801763489),
moTest(1511678068; 7379191741),
moTest(3047753288; 2257683301)
