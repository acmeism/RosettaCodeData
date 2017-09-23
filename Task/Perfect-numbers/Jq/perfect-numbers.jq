def is_perfect:
  . as $in
  | $in == reduce range(1;$in) as $i
      (0; if ($in % $i) == 0 then $i + . else . end);

# Example:
range(1;10001) | select( is_perfect )
