def sum_of_digits_is_substring:
  tostring
  | . as $s
  | (explode | map([.]|implode))
  | (map(tonumber)|add|tostring) as $ss
  | $s | index($ss);

[range(0;1000) | select(sum_of_digits_is_substring)]
