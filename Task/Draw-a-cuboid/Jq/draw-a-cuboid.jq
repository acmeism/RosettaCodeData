def cubLine($n; $dx; $dy; $cde):
  def s: if . == 0 then "" else . * " " end;  # for jaq
  reduce range(1; 9*$dx) as $d ("\($n|s)\($cde[0:1])";
    . + $cde[1:2] )
  + $cde[0:1]
  + ("\($dy|s)\($cde[2:])");

def cuboid($dx; $dy; $dz):
  "cuboid \($dx) \($dy) \($dz):",
  # top
                                  cubLine($dy+1; $dx; 0; "+-"),
  # top and side
  (range(1; 1+$dy) as $i        | cubLine($dy-$i+1; $dx; $i-1; "/ |")),
                                  cubLine(0; $dx; $dy; "+-|"),
  # front and side
  (range(1; 4*$dz -$dy-2) as $i | cubLine(0; $dx; $dy; "| |")),
                                  cubLine(0; $dx; $dy; "| +"),
  # front and bottom
  (range(1; 1+$dy) as $i        | cubLine(0; $dx; $dy-$i; "| /")),
  # bottom
                                  cubLine(0; $dx; 0; "+-\n");

cuboid(2; 3; 4),
"",
cuboid(1; 1; 1),
"",
cuboid(6; 2; 1)
