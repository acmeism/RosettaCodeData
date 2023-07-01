# This function assumes its string arguments represent non-negative decimal integers.
def long_add(num1; num2):
  if (num1|length) < (num2|length) then long_add(num2; num1)
  else  (num1 | explode | map(.-48) | reverse) as $a1
      | (num2 | explode | map(.-48) | reverse) as $a2
      | reduce range(0; num1|length) as $ix
          ($a2;  # result
           ( $a1[$ix] + .[$ix] ) as $r
           | if $r > 9 # carrying
             then
               .[$ix + 1] = ($r / 10 | floor) +
                 (if $ix + 1 >= length then 0 else .[$ix + 1] end )
               | .[$ix] = $r - ( $r / 10 | floor ) * 10
             else
               .[$ix] = $r
             end )
      | reverse | map(.+48) | implode
  end ;
