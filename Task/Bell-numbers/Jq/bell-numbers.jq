# nth Bell number
def bell:
  . as $n
  | if $n < 0 then "non-negative integer expected"
    elif $n < 2 then 1
    else
    reduce range(1; $n) as $i ([1];
      reduce range(1; $i) as $j (.;
        .[$i - $j] as $x
        | .[$i - $j - 1] += $x )
      | .[$i] = .[0] + .[$i - 1] )
      | .[$n - 1]
    end;

# The task
range(1;51) | bell
