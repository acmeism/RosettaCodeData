jq -n '1 as $x | (2 as $x | $x) | $x'
