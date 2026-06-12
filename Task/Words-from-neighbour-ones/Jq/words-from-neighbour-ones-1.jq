# input: the dictionary
# $n: starting point (starting at 0)
def form_word($n):
   . as $dict
   | reduce range(0;9) as $i (""; . + $dict[$n+$i][$i: $i+1] );

[inputs | select(length >= 9)]
| . as $dict
| (reduce.[] as $x ({}; .[$x]=true)) as $hash
| range(0; length-9) as $i | form_word($i) | select($hash[.])
