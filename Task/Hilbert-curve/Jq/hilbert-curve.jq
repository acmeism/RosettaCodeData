include "simple-turtle" {search: "."};

def rules:
   { A: "-BF+AFA+FB-",
     B: "+AF-BFB-FA+" };

def hilbert($count):
  rules as $rules
  | def p($count):
      if $count <= 0 then .
      else gsub("A"; "a") | gsub("B"; $rules["B"]) | gsub("a"; $rules["A"])
      | p($count-1)
      end;
  "A" | p($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(90)
  elif $x == "-" then turtleRotate(-90)
  elif $x == "F" then turtleForward(5)
  else .
  end;

def hilbert_curve($n):
  hilbert($n)
  | split("")
  | reduce .[] as $action (turtle([0,5]) | turtleDown;
      interpret($action) ) ;

hilbert_curve(5)
| path("none"; "red"; 1) | svg(170)
