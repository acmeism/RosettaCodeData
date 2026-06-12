[inputs | select(length >= 9)]
| . as $dict
| (reduce.[] as $x ({}; .[$x]=true)) as $hash
| reduce range(0; length-9) as $i ({$hash};
       ($dict | form_word($i)) as $w
       | if .hash[$w] then .hash[$w] = null | .words += [$w] else . end)
| .words
