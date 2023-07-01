def spiral($a; $b; $step; $h):
  def min($x;$y): if $x <= $y then $x else $y end;
  def max($x;$y): if $x <= $y then $y else $x end;
  def pi: 1 | atan * 4;

  (6 * pi) as $m
  | ($h * 1.5) as $w
  | { x_min: 9999, y_min: 9999,
      x_max:    0, y_max:    0,
      arr: [] }
  | reduce range($step; $m+$step; $step) as $t (.;
      .r = $a + $b * $t
      | ((.r * ($t|cos) + $w) | round) as $x
      | ((.r * ($t|sin) + $h) | round) as $y
      | if   $x <= 0 or $y <= 0 then .
        elif $x >= 280          then .
        elif $y >= 192          then .
        else .arr[$x][$y] = "*"
        | .x_min = min(.x_min; $x)
        | .x_max = max(.x_max; $x)
        | .y_min = min(.y_min; $y)
        | .y_max = max(.y_max; $y)
	end )
  # ... and print it
  | .arr as $arr
  | range(.x_min; .x_max + 1) as $i
  | reduce range(.y_min; .y_max+1) as $j ( "";
      . + ($arr[$i][$j] // " ") )
  | "\(.)\n" ;

spiral(1; 1; 0.02; 96)
