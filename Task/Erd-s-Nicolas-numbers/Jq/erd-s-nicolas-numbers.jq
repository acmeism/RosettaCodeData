# Output a stream of the (unsorted) proper divisors of . including 1
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      ( range(2; 1 + sqrt) as $i
        | if ($n % $i) == 0 then $i,
            (($n / $i) | if . == $i then empty else . end)
         else empty
         end)
    else empty
    end;

# Emit k if . is an Erdos-Nicolas number, otherwise emit 0
def erdosNicolas:
  . as $n
  | ([proper_divisors] | sort) as $divisors
  | ($divisors|length) as $dc
  | if $dc < 3 then 0
    else {sum: ($divisors[0] + $divisors[1])}
    # An Erdos-Nicolas is not perfect, and hence $dc-1 in the following line:
    | first(
        foreach range(2; $dc-1) as $i (.;
          .sum += $divisors[$i]
          | if .sum == $n then .emit = $i + 1
            elif .sum > $n then .emit = 0
            else .
            end )
          | select(.emit).emit  ) // 0
    end ;

limit(8;
  range(2; infinite)
  | . as $n
  | erdosNicolas as $k
  | select($k > 0)
  | "\($n) from \($k)" )
