< /dev/random tr -cd '0-9' | head -c 1000 | jq -R '
  length as $n
  | . as $s
  | ($s[0:5] | tonumber) as $m
  | reduce range(1; $n - 5) as $i ( {min: $m, max: $m};
      ($s[$i: $i+5] | tonumber) as $x
      | if   $x < .min then .min = $x
        elif $x > .max then .max = $x
        else . end)
'
