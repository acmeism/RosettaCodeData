# => =   0 degrees
# ^  =  90 degrees
# <= = 180 degrees
# v  = 270 degrees

# $start : [$x, $y]
def turtle($start):
  $start
  | if type == "array"  then "M \($start|join(","))" else "M 0,0" end
  | {svg: ., up:true, angle:0};

def turtleUp:   .up=true;
def turtleDown: .up=false;

def turtleRotate($angle): .angle = (360 + (.angle + $angle)) % 360;

def turtleForward($d):
  if .up
  then if   .angle==  0 then .svg += " m \($d),0"
       elif .angle== 90 then .svg += " m 0,-\($d)"
       elif .angle==180 then .svg += " m -\($d),0"
       elif .angle==270 then .svg += " m 0,\($d)"
       else "unsupported angle \(.angle)" | error
       end
  else if   .angle==  0 then .svg += " h \($d)"
       elif .angle== 90 then .svg += " v -\($d)"
       elif .angle==180 then .svg += " h -\($d)"
       elif .angle==270 then .svg += " v \($d)"
       else "unsupported angle \(.angle)" | error
       end
  end;

def svg($size):
  "<svg viewBox=\"0 0 \($size) \($size)\" xmlns=\"http://www.w3.org/2000/svg\">",
  .,
  "</svg>";

def path($fill; $stroke; $width):
  "<path fill=\"\($fill)\" stroke=\"\($stroke)\" stroke-width=\"\($width)\" d=\"\(.svg)\" />";

def draw:
  path("none"; "red"; "0.1") | svg(100) ;
