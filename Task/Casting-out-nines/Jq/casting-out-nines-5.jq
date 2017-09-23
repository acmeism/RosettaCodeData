def verify:
  range(1; .)
  | select(is_kaprekar and (co9_equals_co9_squared | not));
