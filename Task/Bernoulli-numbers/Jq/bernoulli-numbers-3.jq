# Using the algorithm in the task description:
def bernoulli(n):
  reduce range(0; n+1) as $m
    ( [];
      .[$m] = ["1", long_add($m|tostring; "1")]  # i.e. 1 / ($m+1)
      | reduce ($m - range(0 ; $m)) as $j
          (.;
            .[$j-1] = multiply( [($j|tostring), "1"]; minus( .[$j-1] ; .[$j]) ) ))
  | .[0] # (which is Bn)
  ;
