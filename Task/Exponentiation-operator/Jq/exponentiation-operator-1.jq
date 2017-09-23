# 0^0 => 1
# NOTE: jq converts very large integers to floats.
# This implementation uses reduce to avoid deep recursion
def power_int(n):
  if n == 0 then 1
  elif . == 0 then 0
  elif n < 0 then 1/power_int(-n)
  elif ((n | floor) == n) then
       ( (n % 2) | if . == 0 then 1 else -1 end ) as $sign
       | if (. == -1) then $sign
         elif . < 0 then (( -(.) | power_int(n) ) * $sign)
         else . as $in | reduce range(1;n) as $i ($in; . * $in)
         end
  else error("This is a toy implementation that requires n be integral")
  end ;
