### Generic functions

def addComplex(stream): reduce stream as [$x,$y] ([0,0]; .[0] += $x | .[1] += $y);

def lpad($len; $x): tostring | ($len - length) as $l | ($x * $l) + .;

# Input: an array
def multiply($x): map(. * $x);

# Round to approx $ndec places
def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

def power($a; $b): reduce range(0;$b) as $i (1; . * $a);

def tau: 8 * atan2(1; 1);

def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  # For jq it would be wise to protect against `infinite` as input, but using `isinfinite` confuses gojq
  select( (tostring|test("^[0-9]+$")) and 2 <= $b and $b <= 36)
  | if . == 0 then "0"
    else [digits | digit] | reverse[1:] | add
    end;

### Sierpinski Pentagons

def svgHead($width):
  "<svg height=\"\($width)\" width=\"\($width)\" style=\"fill:blue\"",
  "version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">";

def svgEnd: "</svg>";

# SVG height and width will be 2 * dim
def pentagon($dim):
  def sides: 5;
  def order: 5;
  def scale: (3 - (order | sqrt)) / 2;

  def cis: [cos, sin];
  def orders:
    [range(0; order) | ((1 - scale) * $dim) * power(scale ; .) ];
  def vertices:
    tau as $tau | [range(0; sides) | ( . * $tau / sides | cis)];

  svgHead(2*$dim),
  (orders as $orders
   | vertices as $vertices
   | range(1; 1 + power(sides; order)) as $i
   | [ ($i|tobase(sides) | lpad(order; "0") | split("")[]) | $vertices[tonumber]] as $varr
   | addComplex(range(0; $orders|length) as $i | $varr[$i] | multiply($orders[$i])) as $vector
   | ($vertices | map( addComplex($vector, multiply($orders[-1] * (1-scale))))) as $vprod
   | ($vprod | map( map(round(3)) | "\(.[0]) \(.[1])") | join(" ")) as $points
   | "<polygon points=\"\($points)\" transform=\"translate(\($dim),\($dim)) rotate(-18)\" />"),
  svgEnd ;

pentagon(250)
