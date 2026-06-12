include "rational" {search: "."};  # see comment above

# Take advantage of gojq's support for infinite-precision integer arithmetic:
# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  (. % $j) as $mod
  | (. - $mod) / $j ;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def properfactors:
  . as $in
  | [2, $in, false]
  | recurse(
      . as [$p, $q, $valid, $s]
      | if $q == 1        then empty
        elif $q % $p == 0 then [$p, ($q|idivide($p)), true]
        elif $p == 2      then [3, $q, false, $s]
        else ($s // ($q | sqrt)) as $s
        | if ($p + 2) <= $s then [$p + 2, $q, false, $s]
          else [$q, 1, true]
          end
        end )
   | if .[2] and .[0] != $in then .[0] else empty end ;

def is_prime:
  [limit(1; properfactors)] | length == 0;

# Use $list to specify which Wolstenholme numbers are to be displayed;
# use $primes to specify the number of prime Wolstenholme numbers to identify.
def wolstenholme($max; $list; $primes):
  {primes: [],  w: [], h: 0}
  | foreach range (1; 1+$max) as $k (.;
      .emit = null
      | .h = radd(.h; r(1; $k * $k))
      | .w += [.h]
      | (.h | .n) as $n
      | if (.primes|length) < $primes and ($n|is_prime) then .primes += [$n] end
      | if $k <= 20
        then .emit = [$k, $n]
        elif ($k | IN($list[]))
        then .emit ="\($k): \($n|tostring[0:20]) (digits: \($n|tostring|length))"
        else .
        end;
      select(.emit).emit,
      (if $k == $max then {primes} else empty end) );


"Wolstenholme numbers:", wolstenholme(10000; [500, 1000, 2500, 5000, 10000]; 4)
