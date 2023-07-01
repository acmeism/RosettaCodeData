# Input: a non-negative integer, $n
# Output: an array of size $n + 1 such that the nth-mobius number is .[$n]
# i.e. $n|mobius_array[-1]
# For example, the first mobius number could be evaluated by 1|mobius_array[-1].
def mobius_array:
  . as $n
  | ($n|sqrt) as $sqrt
  | reduce range(2; 1 + $sqrt) as $i ([range(0; $n + 1) | 1];
       if .[$i] == 1
       then # for each factor found, swap + and -
         reduce range($i; $n + 1; $i) as $j (.; .[$j] *= -$i)
         | ($i*$i) as $isq #  square factor = 0
         | reduce range($isq; $n + 1; $isq) as $j (.; .[$j] = 0 )
       else .
       end )
  | reduce range(2; 1 + $n) as $i (.;
       if   .[$i] ==  $i then .[$i] = 1
       elif .[$i] == -$i then .[$i] = -1
       elif .[$i]  <   0 then .[$i] = 1
       elif .[$i]  >   0 then .[$i] = -1
       else .[$i] = 0                   # avoid "-0"
       end);

# For one-off computations:
def mu($n): $n | mobius_array[-1];
