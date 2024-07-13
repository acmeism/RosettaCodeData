# `div/1` is defined firstly to take advantage of gojq's infinite-precision
# integer arithmetic, and secondly to ensure jaq returns an integer.
def div($j):
  (. - (. % $j)) / $j | round;  # round is for the sake of jaq

# For convenience
def div($i; $j): $i|div($j);

def is_giuga:
  . as $m
  | sqrt as $limit
  | {n: $m, f: 2}
  | until(.ans;
      if (.n % .f) == 0
      then if ((div($m; .f) - 1) % .f) != 0 then .ans = 0
           else .n = div(.n; .f)
           | if .f > .n then .ans = 1 end
           end
      else .f += 1
      | if .f > $limit then .ans = 0 end
      end)
  | .ans == 1 ;

limit(4; range(4; infinite) | select(is_giuga))
