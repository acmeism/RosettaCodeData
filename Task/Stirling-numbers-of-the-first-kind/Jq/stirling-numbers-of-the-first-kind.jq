# For efficiency, define the helper function for `stirling1/2` as a
# top-level function so we can use it directly for constructing the table:
   # input: [m,j,cache]
   # output: [s, cache]
   def stirling1:
    . as [$m, $j, $cache]
    | "\($m),\($j)" as $key
    | $cache
    | if has($key) then [.[$key], .]
      elif $m == 0 and $j == 0 then [1, .]
      elif $m > 0 and $j == 0 then [0, .]
      elif $j > $m then [0, .]
      else ([$m-1, $j-1, .] | stirling1) as [$s1, $c1]
      | ([$m-1, $j, $c1] | stirling1)    as [$s2, $c2]
      | (($s1 +  ($m-1) * $s2)) as $result
      | ($c2 | (.[$key] = $result)) as $c3
      | [$result, $c3]
      end;

def stirling1($n; $k):
  [$n, $k, {}] | stirling1 | .[0];

# produce the table for 0 ... $n inclusive
def stirlings($n):
  # state: [cache, array_of_results]
  reduce range(0; $n+1) as $i ([{}, []];
    reduce range(0; $i+1) as $j (.;
      . as [$cache, $a]
      | ([$i, $j, $cache] | stirling1) as [$s, $c]
      | [$c, ($a|setpath([$i,$j]; $s))] ));

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task($n):
  "Unsigned Stirling numbers of the first kind:",
  "n/k  \( [range(0;$n+1)|lpad(10)] | join(" "))",
   ((stirlings($n) | .[1]) as $a
    | range(0; $n+1) as $i
    | "\($i|lpad(3)): \( [$a[$i][]| lpad(10)] | join(" ") )" ),
  "\nThe maximum value of S1(100, k) is",
  ([stirling1(100; range(0;101)) ] | max) ;

task(12)
