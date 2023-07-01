range(0;5) as $i
| range(0; if $i > 3 then 1 else 6 end) as $j
| "A(\($i),\($j)) = \( [$i,$j] | ack )"
