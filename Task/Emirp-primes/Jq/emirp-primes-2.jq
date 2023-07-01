def is_emirp:
  . as $n
  | tostring | explode | reverse | implode | tonumber | (. != $n) and is_prime ;

# emirps(n) emits [i, p] where p is the i-th emirp, up to and including i == n
def emirps(n):
  label $start
  | # state: [count, $emirp]
  foreach primes as $p ([0, null];
    if .[0] >= n then break $start
    else if ($p | is_emirp) then [.[0] + 1, $p] else .[1] = null end
    end;
    if .[1] then . else empty end ) ;
