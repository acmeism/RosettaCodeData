def dot(x; y):
  reduce range(0;x|length) as $i (0; . + x[$i] * y[$i]);
