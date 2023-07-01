def sierpinski:
  pow(2; .) as $size
  | range($size-1; -1; -1) as $y
  | reduce range(0; $size - $y) as $x ( (" " * $y);
        . + (if ([$x,$y]|bitwise_and) == 0 then "* " else "  " end));

4 | sierpinski
