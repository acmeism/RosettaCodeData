def leap:
  . as $y | ($y%4) == 0 and ($y < 1582 or ($y%400) == 0 or ($y%100) != 0);
