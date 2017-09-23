def rgb2rgb:
  def p: (. + 0.5) | floor;  # to nearest integer
  "rgb(\(.red|p),\(.green|p),\(.blue|p))";

def svg(width; height):
  "<svg width='\(width // "100%")' height='\(height // "100%")'
           xmlns='http://www.w3.org/2000/svg'>";

def pixel(x; y; color):
  (color | if type == "string" then . else rgb2rgb end) as $c
  | "<circle r='1' cx='\(x)' cy='\(y)' fill='\($c)' />";
