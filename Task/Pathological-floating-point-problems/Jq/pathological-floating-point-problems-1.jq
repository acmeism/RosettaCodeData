# Input: the value at which to compute v
def v:
  # Input: cache
  # Output: updated cache
  def v_(n):
    (n|tostring) as $s
    | . as $cache
    | if ($cache | has($s)) then .
      else if n == 1 then $cache["1"] = 2
           elif n == 2 then $cache["2"] = -4
           else ($cache | v_(n-1) | v_(n - 2)) as $new
           | $new[(n-1)|tostring] as $x
 	   | $new[(n-2)|tostring] as $y
           | $new + {($s):  ((111 - (1130 / $x) + (3000 / ($x * $y)))) }
	   end
       end;
    . as $m | {} | v_($m) | .[($m|tostring)] ;
