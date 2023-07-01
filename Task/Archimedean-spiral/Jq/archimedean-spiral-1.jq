def spiral($zero; $turns; $step):

  def pi: 1 | atan * 4;
  def p2: (. * 100 | round) / 100;

  def svg:
    400 as $width
    | 400 as $height
    | 2 as $swidth # stroke
    | "blue" as $stroke
    | (range($zero; $turns * 2 * pi; $step) as $theta
       | (((($theta)|cos) * 2 * $theta + ($width/2)) |p2) as $x
       | (((($theta)|sin) * 2 * $theta + ($height/2))|p2) as $y
       | if $theta == $zero
         then "<path fill='transparent' style='stroke:\($stroke); stroke-width:\($swidth)' d='M \($x) \($y)"
         else " L \($x) \($y)"
         end),
      "' />";

  "<svg width='100%' height='100%'
        xmlns='http://www.w3.org/2000/svg'>",
        svg,
  "</svg>" ;

spiral(0; 10; 0.025)
