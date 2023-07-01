include "simple-turtle" {search: "."};

def rules: {"X": "XF-F+F-XF+F+XF-F+F-X"};

def sierpinski($count):
  rules as $rules
  | def p($count):
      if $count <= 0 then .
      else gsub("X"; $rules["X"]) | p($count-1)
      end;
  "F+XF+F+XF" | p($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(90)
  elif $x == "-" then turtleRotate(-90)
  elif $x == "F" then turtleForward(5)
  else .
  end;

def sierpinski_curve($n):
  sierpinski($n)
  | split("")
  | reduce .[] as $action (turtle([200,650]) | turtleDown;
      interpret($action) ) ;

sierpinski_curve(5)
| path("none"; "red"; 1) | svg(1000)
