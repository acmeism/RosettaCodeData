# Convert a JSON object to a string suitable for use as a CSS style value
# e.g: "font-size: 40px; text-align: center;" (without the quotation marks)
def to_s:
  reduce to_entries[] as $pair (""; . + "\($pair.key): \($pair.value); ");

# Defaults: 100%, 100%
def svg(width; height):
  "<svg width='\(width // "100%")' height='\(height // "100%")'
           xmlns='http://www.w3.org/2000/svg'>";

# Defaults:
#  id: "linearGradient"
#  color1: rgb(0,0,0)
#  color2: rgb(255,255,255)
def linearGradient(id; color1; color2):
  "<defs>
    <linearGradient id='\(id//"linearGradient")' x1='0%' y1='0%' x2='100%' y2='0%'>
      <stop offset='0%' style='stop-color:\(color1//"rgb(0,0,0)");stop-opacity:1' />
      <stop offset='100%' style='stop-color:\(color2//"rgb(255,255,255)");stop-opacity:1' />
    </linearGradient>
  </defs>";

# input: the text string
# "style" should be a JSON object (see for example the default ($dstyle));
# the style actually used is (default + style), i.e. whatever is specified in "style" wins.
# Defaults:
#  x: 0
#  y: 0
def text(x; y; style):
  . as $in
  | {"font-size": "40px", "text-align": "center", "text-anchor": "left", "fill": "black"} as $dstyle
  | (($dstyle + style) | to_s) as $style
  | "<text x='\(x//0)' y='\(y//0)' style='\($style)'>
       \(.)",
     "</text>";
