include "turtle" {search: "."};

def rules:
   { F:  "F+F--F+F",
     "": "F--F--F"  };

def koch($count):
  rules as $rules
  | def repeat($count):
      if $count <= 0 then .
      else gsub("F"; $rules["F"])
      | repeat($count-1)
      end;
  $rules[""] | repeat($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(60)
  elif $x == "-" then turtleRotate(-60)
  elif $x == "F" then turtleForward(4)
  else .
  end;

def koch_curve($n):
  koch($n)
  | split("")
  | reduce .[] as $action (turtle([0,300]) | turtleDown;
      interpret($action) ) ;

koch_curve(5)
| draw(1200)
