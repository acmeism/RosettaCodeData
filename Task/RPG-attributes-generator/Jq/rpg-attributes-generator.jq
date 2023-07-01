def count(s): reduce s as $x (0; .+1);

# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# Output: [$four, $sum]
# where $four is an array of 4 pseudo-random integers between 1 and 6 inclusive,
# and $sum records the sum of the 3 largest values.
def generate_RPG:
   [range(0; 4) | (1 + (7|prn) )] as $four
   | [$four, ($four|sort|.[-3:]|add)];

# Input: $six as produced by [range(0;6) | generate_RPG]
# Determine if the following conditions are met:
# - the total of all 6 of the values at .[-1] is at least 75;
# - at least 2 of these values must be 15 or more.
def ok:
  ([.[][-1]] | add) as $sum
  | $sum >= 75 and
      count( (.[][1] >= 15) // empty) >= 2;

# First show [range(0;6) | generate_RPG]
# and then determine if it meets the "ok" condition;
# if not, repeat until a solution has been found.
def task:
  [range(0;6) | generate_RPG] as $six
  | ([$six[][-1]] | add) as $sum
  | $six[], "Sum: \($sum)",
    if $six | ok then "All done."
    else "continuing search ...",
    ({}
     | until(.emit;
         [range(0;6) | generate_RPG] as $six
         | ([$six[][-1]] | add) as $sum
         | if $six | ok
           then .emit = {$six, $sum}
           else .
           end).emit
      | (.six[], "Sum: \(.sum)" ) )
    end;

task
