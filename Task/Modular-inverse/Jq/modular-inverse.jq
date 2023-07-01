# Integer division:
# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# the multiplicative inverse of . modulo $n
def modInv($n):
  if $n == 1 then 1
  else . as $this
  | { r   : $n,
      t   : 0,
      newR: length, # abs
      newT: 1}
  | until(.newR == 0;
        .newR as $newR
        | (.r | idivide($newR)) as $q
        | {r   : $newR,
           t   : .newT,
           newT: (.t - $q * .newT),
           newR: (.r - $q * $newR) } )
	
  | if (.r|length) != 1 then "\($this) and \($n) are not co-prime." | error
    else .t
    | if .     < 0 then . + $n
      elif $this < 0 then - .
      else .
      end
    end
  end ;

# Example:
42 | modInv(2017)
