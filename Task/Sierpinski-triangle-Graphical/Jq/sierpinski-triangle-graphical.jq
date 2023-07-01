include "turtle" {search: "."};

# Compute the curve using a Lindenmayer system of rules
def rules:
 # "H" signfies Horizontal motion
 {X: "XX",
  H: "H--X++H++X--H",
  "": "H--X--X"};

def sierpinski($count):
  rules as $rules
  | def repeat($count):
      if $count == 0 then .
      else gsub("X"; $rules["X"]) | gsub("H"; $rules["H"])
      | repeat($count-1)
      end;
  $rules[""] | repeat($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(-60)
  elif $x == "-" then turtleRotate(60)
  else turtleForward(20)
  end;

def sierpinski_curve($n):
  sierpinski($n)
  | split("")
  | reduce .[] as $action (
      turtle([200,-200]) | turtleDown;
      interpret($action) ) ;

# viewBox = <min-x> <min-y> <width> <height>
# Input: {svg, minx, miny, maxx, maxy}
def svg:
  "<svg viewBox='\(.minx|floor) \(.miny - 4 |floor) \(.maxx - .minx|ceil) \(6 + .maxy - .miny|ceil)'",
  "     preserveAspectRatio='xMinYmin meet'",
  "     xmlns='http://www.w3.org/2000/svg' >",
  path("none"; "red"; 1),
  "</svg>";

sierpinski_curve(5)
| svg
