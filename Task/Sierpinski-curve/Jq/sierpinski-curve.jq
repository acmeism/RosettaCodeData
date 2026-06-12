include "turtle" {search: "."};

# Compute the curve using a Lindenmayer system of rules
def rules:
  { X: "XF+G+XF--F--XF+G+X",
   "": "F--XF--F--XF" };

def sierpinski($count):
  rules as $rules
  | def p($count):
      if $count == 0 then .
      else gsub("X"; $rules["X"]) | p($count-1)
      end;
  $rules[""] | p($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(45)
  elif $x == "-" then turtleRotate(-45)
  elif $x == "F" or $x == "G" then turtleForward(5)
  else .
  end;

def sierpinski_curve($n):
  sierpinski($n)
  | split("")
  | reduce .[] as $action (
      turtle([100,100]) | turtleDown;
      interpret($action) ) ;

# viewBox = <min-x> <min-y> <width> <height>
# Input: {svg, minx, miny, maxx, maxy}
def svg:
  "<svg viewBox='\(.minx|floor) \(.miny - 2 |floor) \(.maxx - .minx|ceil) \(2 + .maxy - .miny|ceil)'",
  "     preserveAspectRatio='xMinYmin meet'",
  "     xmlns='http://www.w3.org/2000/svg' >",
  path("none"; "red"; 1),
  "</svg>";

sierpinski_curve(5)
| svg
