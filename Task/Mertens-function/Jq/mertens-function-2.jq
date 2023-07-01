# Input: $max >= 1
# Output: an array of size $max with $max mertenNumbers beginning with 1
def mertensNumbers:
  . as $max
  | reduce range(2; $max + 1) as $n ( [1];
      .[$n-1]=1
      | reduce range(2; $n+1) as $k (.;
          .[$n-1] -= .[($n / $k) | floor - 1] ));
