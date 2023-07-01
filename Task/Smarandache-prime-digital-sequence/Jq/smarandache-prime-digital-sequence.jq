def Smarandache_primes:
  # Output: a naively constructed stream of candidate strings of length >= 1
  def Smarandache_candidates:
    def unconstrained($length):
      if $length==1 then "2", "3", "5", "7"
      else ("2", "3", "5", "7") as $n
      | $n + unconstrained($length -1 )
      end;
    unconstrained(. - 1) as $u
    |  ("3", "7") as $tail
    | $u + $tail ;

  2,3,5,7,
  (range(2; infinite) | Smarandache_candidates | tonumber | select(is_prime));

# Override jq's incorrect definition of nth/2
# Emit the $n-th value of the stream, counting from 0; or emit nothing
def nth($n; s):
 if $n < 0 then error("nth/2 doesn't support negative indices")
 else label $out
 | foreach s as $x (-1; .+1; select(. >= $n) | $x, break $out)
 end;

"First 25:",
[limit(25; Smarandache_primes)],

# jq counts from 0 so:
"\nThe hundredth: \(nth(99; Smarandache_primes))"
