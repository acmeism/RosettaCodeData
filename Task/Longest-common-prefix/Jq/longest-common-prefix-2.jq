def longest_common_prefix:
 if length == 0 then ""        # by convention
 elif length == 1 then .[0]    # for speed
 else sort
 | if .[0] == "" then ""       # for speed
   else .[0] as $first
   |    .[length-1] as $last
   | ([$first, $last] | map(length) | min) as $n
   | 0 | until( . == $n or $first[.:.+1] != $last[.:.+1]; .+1)
   | $first[0:.]
   end
 end;
