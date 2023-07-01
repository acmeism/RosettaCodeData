# unordered
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      ( range(2; 1 + (sqrt|floor)) as $i
        | if ($n % $i) == 0 then $i,
            (($n / $i) | if . == $i then empty else . end)
         else empty
	 end)
    else empty
    end;

# Is n semiperfect given that divs are the proper divisors
def semiperfect(n; divs):
  (divs|length) as $le
  | if $le == 0 then false
    else divs[0] as $h
    | if n == $h then true
      elif $le == 1 then false
      else  divs[1:] as $t
      | if n < $h then semiperfect(n; $t)
        else semiperfect(n-$h; $t) or semiperfect(n; $t)
	end
      end
    end ;

def sieve(limit):
    # 'false' denotes abundant and not semi-perfect.
    # Only interested in even numbers >= 2
    (reduce range(6; limit; 6) as $j ([]; .[$j] = true)) # eliminates multiples of 3
    | reduce range(2; limit; 2) as $i (.;
        if (.[$i]|not)
        then [$i|proper_divisors] as $divs
        | ($divs | add) as $sum
        | if $sum <= $i
          then .[$i] = true
          elif (semiperfect($sum-$i; $divs))
          then reduce range($i; limit; $i) as $j (.; .[$j] = true)
          else .
          end
	else .
	end) ;

# Print up to $max weird numbers based on the given sieve size, $limit.
def task($limit; $max):
  sieve($limit) as $w
  | def weirds:
      range(2; $w|length; 2) | select($w[.]|not);

      # collect into an array for ease of counting
      [limit($max; weirds)]
      | "The first \(length) weird numbers are:", . ;

# The parameters should be set on the command line:
task($sieve; $limit)
