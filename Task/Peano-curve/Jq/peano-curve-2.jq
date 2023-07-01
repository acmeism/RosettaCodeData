# Compute the curve using a Lindenmayer system of rules
def rules:
  { L: "LFRFL-F-RFLFR+F+LFRFL",
    R: "RFLFR+F+LFRFL-F-RFLFR" } ;

def peano($count):
  rules as $rules
  | def p($count):
      if $count <= 0 then .
      else gsub("L"; "l") | gsub("R"; $rules["R"]) |  gsub("l"; $rules["L"]) | p($count-1)
      end;
  "L" | p($count) ;

def interpret($x):
  if   $x == "+" then turtleRotate(90)
  elif $x == "-" then turtleRotate(-90)
  elif $x == "F" then turtleForward(1)
  else .
  end;

def peano_curve($n):
  peano($n)
  | split("")
  | reduce .[] as $action (turtle([1,1]) | turtleDown;
      interpret($action) ) ;

peano_curve(4)
| draw
