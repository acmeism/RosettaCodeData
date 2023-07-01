# viewBox = <min-x> <min-y> <width> <height>
# Input: {svg, minx, miny, maxx, maxy}
def svg:
  "<svg viewBox='\(.minx - 4|floor) \(.miny - 4 |floor) \(6 + .maxx - .minx|ceil) \(6 + .maxy - .miny|ceil)'",
  "     preserveAspectRatio='xMinYmin meet'",
  "     xmlns='http://www.w3.org/2000/svg' >",
  .svg,
  "</svg>";

def minmax($xy):
    .minx = ([.minx, $xy[0]]|min)
  | .miny = ([.miny, $xy[1]]|min)
  | .maxx = ([.maxx, $xy[0]]|max)
  | .maxy = ([.maxy, $xy[1]]|max) ;

# default values for $fill and $stroke are provided
def Polygon( $ary; $fill; $stroke):
  def rnd: 1000*.|round/1000;
  ($fill // "none") as $fill
  | ($stroke // "black") as $stroke
  | ($ary | map(rnd) | join(" ")) as $a
  | .svg += "\n<polygon points='\($a)' fill='\($fill)' stroke='\($stroke)' />"
  | minmax($ary | [ ([ .[ range(0;length;2)]] |min),  ([ .[range(1;length;2)]]|min) ] )
  | minmax($ary | [ ([ .[ range(0;length;2)]] |max),  ([ .[range(1;length;2)]]|max) ] ) ;


def Square($A; $B; $C; $D; $fill; $stroke):
  Polygon( $A + $B + $C + $D; $fill; $stroke);

def Triangle($A; $B; $C; $fill; $stroke):
  Polygon( $A + $B + $C; $fill; $stroke);

def PythagorasTree:

  def drawTree($x1; $y1; $x2; $y2; $depth):
    if $depth <= 0 then .
    else ($x2 - $x1) as $dx
         | ($y1 - $y2) as $dy
         | ($x2 - $dy) as $x3
	 | ($y2 - $dx) as $y3
         | ($x1 - $dy) as $x4
         | ($y1 - $dx)  as $y4
	 | ($x4 + 0.5 * ($dx - $dy)) as $x5
         | ($y4 - 0.5 * ($dx + $dy)) as $y5

         # draw a square
	 | "rgb(\(256 - $depth * 20), 0, 0)" as $col
         | Square([$x1, $y1]; [$x2, $y2]; [$x3, $y3] ;  [$x4, $y4] ; $col; "lightgray")

         # draw a triangle
         | "rgb( 128, \(256 - $depth * 20), 128)" as $col
         | Triangle([$x3, $y3]; [$x4, $y4];  [$x5, $y5];  $col; "lightgray")
         | drawTree($x4; $y4; $x5; $y5; $depth - 1)
         | drawTree($x5; $y5; $x3; $y3; $depth - 1)
    end ;

  {svg: "", minx: infinite, miny: infinite, maxx: -infinite, maxy: -infinite}
  | drawTree(275; 500; 375; 500; 7);

PythagorasTree | svg
