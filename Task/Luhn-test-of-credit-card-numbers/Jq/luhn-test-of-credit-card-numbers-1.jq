def luhn:
  def odds: . as $in | reduce range(0; length) as $i
    ([]; if ($i % 2) == 0 then . + [$in[$i]] else . end);
  def evens: . as $in | reduce range(1; length) as $i
    ([]; if ($i % 2) == 1 then . + [$in[$i]] else . end);
  def digits: map([.]|implode|tonumber);
  def sumdigits: tostring | explode | digits | add;

  (tostring | explode | reverse ) as $reverse
  | ($reverse | odds  | digits | add) as $s1
  | ($reverse | evens | digits | map(. * 2 | sumdigits) | add) as $s2
  | 0 == ($s1 + $s2) % 10 ;
