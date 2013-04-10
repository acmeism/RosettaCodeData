sub sma ($)
 {my ($period, $sum, @a) = shift, 0;
  return sub
     {unshift @a, shift;
      $sum += $a[0];
      @a > $period and $sum -= pop @a;
      return $sum / @a;}}
