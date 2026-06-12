def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

[range(2;6) as $a | range(2;6) as $b | $a|power($b)] | unique
