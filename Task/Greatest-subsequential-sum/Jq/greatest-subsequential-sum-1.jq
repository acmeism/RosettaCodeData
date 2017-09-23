def subarray_sum:
  . as $arr
  | reduce range(0; length) as $i
      ( {"first": length, "last": 0, "curr": 0, "curr_first": 0, "max": 0};
        $arr[$i] as $e
        | (.curr + $e) as $curr
        | . + (if $e > $curr then {"curr": $e, "curr_first": $i} else {"curr": $curr} end)
        | if .curr > .max then . + {"max": $curr, "first": .curr_first, "last": $i}
          else .
          end)
  | [ .max, $arr[ .first : (1 + .last)] ];
