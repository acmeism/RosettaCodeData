include "turtle" {search: "."};

# Compute the curve using a Lindenmayer system of rules
def rules:
  {X: "Yf+Xf+Y", Y: "Xf-Yf-X", "": "X"};

def sierpinski($count):
  rules as $rules
  | def repeat($count):
      if $count == 0 then .
      else ascii_downcase | gsub("x"; $rules["X"]) | gsub("y"; $rules["Y"])
      | repeat($count-1)
      end;
  $rules[""] | repeat($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(60)
  elif $x == "-" then turtleRotate(-60)
  elif $x == "f" then turtleForward(3)
  else .
  end;

def sierpinski_curve($n):
  sierpinski($n)
  | split("")
  | reduce .[] as $action (
      turtle([0,-350]) | turtleDown | turtleRotate(60);
      interpret($action) ) ;

# viewBox = <min-x> <min-y> <width> <height>
# Input: {svg, minx, miny, maxx, maxy}
def svg:
  "<svg viewBox='\(.minx|floor) \(.miny - 4 |floor) \(.maxx - .minx|ceil) \(6 + .maxy - .miny|ceil)'",
  "     preserveAspectRatio='xMinYmin meet'",
  "     xmlns='http://www.w3.org/2000/svg' >",
  path("none"; "red"; 1),
  "</svg>";

sierpinski_curve(8)
| svg
