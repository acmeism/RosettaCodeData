jq -n '1 as $a | 2 as $b | $a as $tmp | $b as $a | $tmp as $b | [$a,$b]'
