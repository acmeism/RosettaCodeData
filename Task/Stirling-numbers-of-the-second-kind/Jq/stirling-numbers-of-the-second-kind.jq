def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Input:  {computed} (the cache)
# Output: {computed, result}
def stirling2($n; $k):
  "\($n),\($k)" as $key
  | if .computed[$key] then .result = .computed[$key]
    elif ($n == 0 and $k == 0) then .result = 1
    elif (($n > 0 and $k == 0) or ($n == 0 and $k > 0)) then .result = 0
    elif ($k == $n) then .result = 1
    elif ($k > $n) then .result = 0
    else stirling2($n-1; $k-1) as $s1
    | ($s1 | stirling2($n-1; $k)) as $s2
    | ($s1.result + ($k * $s2.result)) as $result
    | $s2
    | .computed[$key] = $result
    | .result = $result
    end ;

# Set .emit to a table of values and .computed to a cache of stirling2 values
# Output: {emit, computed}
def part1(max):
  {emit: "Unsigned Stirling numbers of the second kind:"}
  | .emit += "\n" + "n/k" +
      ([range(0; max+1) | lpad(10)] | join(""))
  | reduce range(0; max+1) as $n ( .computed = {};
      .emit += "\n" + ($n | lpad(3))
      | reduce range(0; $n+1) as $k (.;
          stirling2($n; $k)
          | .emit += (.result | lpad(10) ) )) ;

# "The maximum value of S2($m, k) ..."
# Input: {computed}
def part2($m):
  "The maximum value of S2(\($m), k) =",
   first(
     foreach range(1;$m+1) as $k ({computed:{}, previous: 0};
       stirling2($m; $k) as $current
       | if ($current.result > .previous)
         then .previous = $current.result
         else
           .emit = "\(.previous)\n(\(.previous|tostring|length) digits, k = \($k - 1))"
         end;
       select(.emit).emit) );

part1(12)
| .emit,
  part2(100)
