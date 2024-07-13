# Generic filters:

# Integer division (for gojq and jaq)
# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  (. % $j) as $mod
  | (. - $mod) / $j | round;

# Convert the input integer to a stream of 0s and 1s, least significant bit first
def bitwise:
  recurse( if . >= 2 then idivide(2) else empty end) | . % 2;

def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else sqrt as $s
    | 23
    | until( . > $s or ($n % . == 0); . + 2)
    | . > $s
    end;

### Factors of Mersene numbers

def trialFactor($base; $exp; $mod):
  [$exp | bitwise] as $bits
  | ($bits|length) as $length
  | reduce range( 0; $length) as $i (1;
        (. * . * (if $bits[$length-$i-1] == 1 then $base else 1 end)) % $mod )
  | . == 1 ;

def mersenneFactor($p):
  ((pow(2;$p) - 1) | sqrt | floor) as $limit
  | {k: 1}
  | until ((2*.k*$p - 1) >= $limit or .emit;
      (2*.k*$p + 1 ) as $q
      | if ($q%8 == 1 or $q%8 == 7) and trialFactor(2; $p; $q) and ($q | is_prime)
        then .emit = $q  # q is a factor of 2^p - 1
        else .k += 1
        end)
  | if .emit then .emit else null end;

### Examples:

def m: [3, 5, 11, 17, 23, 29, 31, 37, 41, 43, 47, 53, 59, 67, 71, 73, 79, 83, 97, 929];

m[]
| mersenneFactor(.) as $f
| "2^\(.) - 1 is " +
  if $f then "composite (factor \($f))"
  else "prime"
  end
