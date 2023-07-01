# Input: {svg, minx, miny, maxx, maxy}
def svg:
  # viewBox = <min-x> <min-y> <width> <height>
  "<svg viewBox='\(.minx - 4|floor) \(.miny - 4 |floor) \(6 + .maxx - .minx|ceil) \(6 + .maxy - .miny|ceil)'",
  "     preserveAspectRatio='xMinYmin meet'",
  "     xmlns='http://www.w3.org/2000/svg' >",
  .svg,
  "</svg>" ;

# Input: an array of [x,y] points
def minmax:
  {minx: (map(.[0])|min),
   miny: (map(.[1])|min),
   maxx: (map(.[0])|max),
   maxy: (map(.[1])|max)} ;

# Input: an array of [x,y] points
def Polyline($fill; $stroke; $transform):
  def rnd: 1000*.|round/1000;
  def linearize: map( map(rnd) | join(" ") ) | join(", ");

  "<polyline points='"
   + linearize
   + "'\n style='fill:\($fill); stroke: \($stroke); stroke-width:3;'"
   + "\n transform='\($transform)' />" ;

# Output: {minx, miny, maxx, maxy, svg}
def pentagram($dim):
  (8 * (1|atan)) as $tau
  | 5 as $sides
  | [ (0, 2, 4, 1, 3, 0)
     | [  0.9 * $dim * (($tau * $v / $sides) | cos),
          0.9 * $dim * (($tau * $v / $sides) | sin) ] ]
  | minmax
    + {svg: Polyline("seashell"; "blue"; "rotate(-18)" )} ;

pentagram(200)
| svg
