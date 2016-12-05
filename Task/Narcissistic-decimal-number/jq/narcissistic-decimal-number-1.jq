def is_narcissistic:
  def digits: tostring | explode[] | [.] | implode | tonumber;
  def pow(n): . as $x | reduce range(0;n) as $i (1; . * $x);

  (tostring | length) as $len
  | . == reduce digits as $d (0;  . + ($d | pow($len)) )
  end;
