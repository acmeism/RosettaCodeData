"abc" | . as $s | range(0;length) | $s[.:.+1]

"abc" | explode | map( [.]|implode) | .[]
