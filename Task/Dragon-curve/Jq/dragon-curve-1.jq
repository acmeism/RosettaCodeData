include "simple-turtle" {search: "."};

def rules:
   { F: "F+S",
     S: "F-S" };

def dragon($count):
  rules as $rules
  | def p($count):
      if $count <= 0 then .
      else gsub("S"; "s") | gsub("F"; $rules["F"]) | gsub("s"; $rules["S"])
      | p($count-1)
      end;
  "F" | p($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(90)
  elif $x == "-" then turtleRotate(-90)
  elif $x == "F" then turtleForward(4)
  elif $x == "S" then turtleForward(4)
  else .
  end;

def dragon_curve($n):
  dragon($n)
  | split("")
  | reduce .[] as $action (turtle([200,300]) | turtleDown;
      interpret($action) ) ;

dragon_curve(15)
| path("none"; "red"; "0.1") | svg(1700)
