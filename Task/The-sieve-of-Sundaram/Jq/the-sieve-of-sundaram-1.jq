# `sieve_of_Sundaram` as defined here generates the stream of
# consecutive primes from 3 on but less than or equal to the specified
# limit specified by `.`.
# input: an integer, n
# output: stream of consecutive primes from 3 but less than or equal to n
def sieve_of_Sundaram:
    def idiv($b): (. - (. % $b))/$b ;
    debug |
    round as $n
    | if $n < 2 then empty
      else
        ((($n-3) | idiv(2)) + 1) as $k
        | [range(0; $k + 1) | 1 ] # integers_list
        | reduce range (0; (($n|sqrt) - 3) / 2 + 1) as $i (.;
            (2*$i + 3) as $p
            | ((($p*$p - 3) | idiv(2))) as $s
            | reduce range($s; $k; $p) as $j (.;
	        if .[$j] then .[$j] = false else . end ) )
        | range(0; $k) as $i
        | if .[$i] then ($i+1)*2+1 else empty end
      end ;

# Emit an array of $n Sundaram primes.
# The first Sundaram prime is 3 so we ensure Sundaram_prime(1) is [3].
# An adaptive definition to ensure generality without being excessively conservative.
def Sundaram_primes($n):
  def sieve:
     . as $in
     | [limit($n; sieve_of_Sundaram)]
     | if length == $n then .
       else ($n + $in) as $m
       | ("... nth_Sundaram_prime(\($n)): \($in) => \($m))" | debug) as $debug
       | $m | sieve
       end;
  if $n < 1 then empty
  elif $n <= 100 then ($n | 1.2 * . * log) | sieve
  else $n | (1.15 * . * log) | sieve # OK
  end;
