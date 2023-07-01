include "primeSieve";  # or copy-and-paste its def

def when(filter; action): if filter // null then action else . end;

def results($cat; $lim; $max; $array):
  ($array|length) as $len
  | (if $cat != "unsexy primes" then "sexy prime " + $cat else $cat end) as $cat
  | (if $len < $max then $len else $max end) as $last
  | (if $last == 1 then "is" else "are" end) as $verb
  | "Number of \($cat) less than \($lim) = \($len)",
    "The last \($max) \($verb):\n  \($array[ - $last :])\n";

def task($lim):
  (($lim-1) | primeSieve) as $sieve   # $sieve[i] iff i is prime
  | { pairs:[], trips:[], quads:[], quins:[], unsexy:[2, 3], i: 3 }
  | until (.i >= $lim;
      if .i > 5 and .i < $lim-6 and $sieve[.i] and ($sieve[.i-6]|not) and ($sieve[.i+6]|not)
      then .unsexy += [.i]
      else when(.i < $lim-6 and $sieve[.i] and $sieve[.i+6];
             .pairs += [[.i, .i+6]]
             | when(.i < $lim-12 and $sieve[.i+12];
                 .trips += [[.i, .i+6, .i+12]]
                 | when(.i < $lim-18 and $sieve[.i+18];
                     .quads += [[.i, .i+6, .i+12, .i+18]]
                     | when(.i < $lim-24 and $sieve[.i+24];
                         .quins += [[.i, .i+6, .i+12, .i+18, .i+24]]))))
      end
      | .i += 2 )
  | results("pairs";         $lim; 5; .pairs),
    results("triplets";      $lim; 5; .trips),
    results("quadruplets";   $lim; 5; .quads),
    results("quintuplets";   $lim; 5; .quins),
    results("unsexy primes"; $lim; 10; .unsexy)
;

task(1000035)
