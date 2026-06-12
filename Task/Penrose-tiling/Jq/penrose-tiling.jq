def pi: 4 * (1|atan);

def rules:
  {A : "",
   M : "OA++PA----NA[-OA----MA]++",
   N : "+OA--PA[---MA--NA]+",
   O : "-MA++NA[+++OA++PA]-",
   P : "--OA++++MA[+PA++++NA]--NA",
   "": "[N]++[N]++[N]++[N]++[N]" } ;

# Apply the rules
def penrose($count):
  rules as $rules
  | def repeat($count):
      if $count <= 0 then .
      else gsub("M";"m") | gsub("N";"n") | gsub("O";"o")  | gsub("P";"p")
      | gsub("A"; $rules["A"])
      | gsub("m"; $rules["M"])
      | gsub("n"; $rules["N"])
      | gsub("o"; $rules["O"])
      | gsub("p"; $rules["P"])
      | repeat($count-1)
      end;
  $rules[""] | repeat($count) ;

# Update {svg, x, y, theta, stack, minx, maxx, miny, maxy}
def interpret($z):
  def rnd: 1000*.|round/1000;
  def minmax:
      .minx = ([.minx, .x]|min)
    | .miny = ([.miny, .y]|min)
    | .maxx = ([.maxx, .x]|max)
    | .maxy = ([.maxy, .y]|max) ;

  if   $z == "+" then .theta += pi/5
  elif $z == "-" then .theta -= pi/5
  elif $z == "[" then .stack += [ {x, y, theta} ]
  elif $z == "]" then .stack[-1] as {$x, $y, $theta}
  | .x = $x | .y = $y | .theta = $theta
  | .stack |= .[:-1]
  elif $z == "A"
  then minmax
  | .r as $r
  |.svg += "<line x1='\(.x|rnd)' y1='\(.y|rnd)' "
  | .x += $r * (.theta|cos)
  | .y += $r * (.theta|sin)
  | .svg += "x2='\(.x|rnd)' y2='\(.y|rnd)' "
  | .svg += "style='stroke:rgb(255,165,0)'/>\n"
  | minmax
  else .
  end ;

def penrose_tiling($n):
  penrose($n)
  | split("")
  | reduce .[] as $action (
      {x:160, y:160, theta: (pi/5), r: 20,
       minx: infinite, miny: infinite,
       maxx: -infinite, maxy: -infinite,
      svg: "", stack: []};
      interpret($action) ) ;

# viewBox = <min-x> <min-y> <width> <height>
# Input: {svg, minx, miny, maxx, maxy}
def svg:
  ([.minx, .miny] | min - 2 | floor) as $min
  | ([.maxx - .minx,  .maxy - .miny] | max + 2 | ceil) as $size
  | "<svg viewBox=\"\($min) \($min) \($size) \($size)\" xmlns=\"http://www.w3.org/2000/svg\">",
    .svg,
    "</svg>";

penrose_tiling(5)
| svg
