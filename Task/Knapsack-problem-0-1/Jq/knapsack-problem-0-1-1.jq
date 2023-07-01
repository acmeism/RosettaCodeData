# Input should be the array of objects giving name, weight and value.
# Because of the way addition is defined on null and because of the
# way setpath works, there is no need to initialize the matrix m in
# detail.
def dynamic_knapsack(W):
  . as $objects
  | length as $n
  | reduce range(1; $n+1) as $i                           # i is the number of items
      # state: m[i][j] is an array of [value, array_of_object_names]
      (null;                           # see above remark about initialization of m
       $objects[$i-1] as $o
       | reduce range(0; W+1) as $j
           ( .;
             if $o.weight <= $j then
               .[$i-1][$j][0] as $v1                               # option 1: do not add this object
               | (.[$i-1][$j - $o.weight][0] + $o.value) as $v2    # option 2: add it
               | (if $v1 > $v2 then
                       [$v1, .[$i-1][$j][1]]                       # do not add this object
                  else [$v2, .[$i-1][$j - $o.weight][1]+[$o.name]] # add it
                  end) as $mx
               | .[$i][$j] = $mx
             else
                 .[$i][$j] = .[$i-1][$j]
             end))
  | .[$n][W];
