# SVG headers
def svg(size):
  "<svg xmlns='http://www.w3.org/2000/svg' width='\(size)'",
  "height='\(size)' style='stroke:gold'>",
  "<rect width='100%' height='100%' fill='black'/>";

# emit the "<circle />" elements
def sunflower(size):
  def rnd: 100*.|round/100;

  (5 * size) as $seeds
  | ((1|atan) * 4) as $pi
  | ((1 + (5|sqrt)) / 2) as $phi
  | range(1; 1 + $seeds) as $i
  | {}
  | .r = 2 * pow($i; $phi)/$seeds
  | .theta = 2 * $pi * $phi * $i
  | .x = .r * (.theta|sin) + size/2
  | .y = .r * (.theta|cos) + size/2
  | .radius = ($i|sqrt)/13
  | "<circle cx='\(.x|rnd)' cy='\(.y|rnd)' r='\(.radius|rnd)' />" ;

def end_svg:
  "</svg>";

svg(600),
sunflower(600),
end_svg
