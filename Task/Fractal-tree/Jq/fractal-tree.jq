# width and height define the outer dimensions;
# len defines the trunk size;
# scale defines the branch length relative to the trunk;
def main(width; height; len; scale):

  def PI: (1|atan)*4;

  def precision(n):
    def pow(k): . as $in | reduce range(0;k) as $i (1; .*$in);
    if . < 0 then - (-. | precision(n))
    else
      (10|pow(n)) as $power
    | (. * 10 * $power) | floor as $x | ($x % 10) as $r
    | ((if $r < 5 then $x else $x + 5 end) / 10 | floor) / $power
    end;

  def p2: precision(2);

  def tree(x; y; len; angle):
    if len < 1 then empty
    else
      (x + len * (angle|cos)) as $x2
    | (y + len * (angle|sin)) as $y2
    | (if len < 10 then 1 else 2 end) as $swidth
    | (if len < 10 then "blue" else "black" end) as $stroke
    | "<line x1='\(x|p2)' y1='\(y|p2)' x2='\($x2|p2)' y2='\($y2|p2)' style='stroke:\($stroke); stroke-width:\($swidth)'/>",
      tree($x2; $y2; len * scale; angle + PI / 5),
      tree($x2; $y2; len * scale; angle - PI / 5)
    end
  ;

  "<svg width='100%' height='100%' version='1.1'
        xmlns='http://www.w3.org/2000/svg'>",
        tree(width / 2; height; len; 3 * PI / 2),
  "</svg>"
;

main(1000; 1000; 400; 6/10)
