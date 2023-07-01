def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

5|power(4|power(3|power(2))) | tostring
| .[:20], .[-20:], length
