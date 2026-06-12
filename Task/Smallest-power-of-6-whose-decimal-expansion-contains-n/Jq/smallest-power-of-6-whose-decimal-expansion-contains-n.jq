# To preserve precision:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

range(0;22)
| . as $in
| tostring as $n
| first(range(0;infinite) as $i | 6 | power($i) | . as $p | tostring | (index($n) // empty)
        | [$in,$i,$p] )
