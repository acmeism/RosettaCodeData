def max(s): reduce s as $x (-infinite;  if $x > . then $x else . end);
def min(s): reduce s as $x ( infinite;  if $x < . then $x else . end);

# An unbounded stream
def fibonacci_words:
  "1",
  (["0","1"] | recurse( [add, .[0]]) | .[0]);

def turnLeft:
  {"R": "U",
   "U": "L",
   "L": "D",
   "D": "R"};

def turnRight:
  {"R": "D",
   "D": "L",
   "L": "U",
   "U": "R"};

# Input: the remaining Fibonacci word
# $n should initially be 1 and represents
# 1 plus the count of the letters already processed.
#
# Emit a stream of single-letter directions ("1" for forward),
# namely, if current char is 0
# - turn left if $n is even
# - turn right if $n is odd
def directions($n):
  if length == 0 then empty
  else .[0:1] as $c
  | (if $c == "0"
    then if $n % 2 == 0 then "L" else "R" end
    else "1"
    end),
    (.[1:] | directions($n+1))
  end;

# $current is the direction in which we are currently pointing.
# output: the direction in which the next step should be taken
def next_step($current; $turn):
   if   $turn == "1" then $current
   elif $turn == "L" then turnLeft[$current]
   elif $turn == "R" then turnRight[$current]
   else error
   end;

# input: a Fibonacci word
# output: a stream of directions for turning, or "1" for not turning,
# i.e. a stream of: U, D, L, R, or 1
# Initially, we are facing R
def steps:
  foreach directions(1) as $turn ("R";
     next_step(.; $turn) );

# output a stream of [x,y] co-ordinates corresponding to the specified
# stream of steps of the given size.
# So we could for example call: points( nth(5; fibonacci_words) | steps; $size)
def points(steps; $size):
   foreach steps as $step ([0,0];
      . as [$x, $y]
      | if   $step == "R" then [$x + $size, $y]
        elif $step == "D" then [$x, $y + $size]
        elif $step == "L" then [$x - $size, $y]
        elif $step == "U" then [$x, $y - $size]
	else error
	end );

# svg header boilerplate
# viewBox = '<min-x> <min-y> <width> <height>'
def svg($minX; $minY; $width; $height):
  "<?xml version='1.0' standalone='no'?>",
  "<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN' 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>",
  "<svg viewBox='\($minX - 10) \($minY - 10) \($width + 20) \($height + 20)' version='1.1' xmlns='http://www.w3.org/2000/svg'>";

# input: array of [x,y] co-ordinates
# output: "<polyline .... />"
def polyline:
  {a:1, b:1} as $p
  | "<polyline points='\(map(join(","))|join(" "))'",
    " style='fill:none; stroke:black; stroke-width:1' transform='translate(\($p.a), \($p.b))' />";

# Output the svg for the $n-th Fibonacci word counting from 0
def fibonacci_word_svg($n):
  [points( nth($n; fibonacci_words) | steps; 10)]
  | min( .[] | .[0]) as $minx
  | max( .[] | .[0]) as $maxx
  | min( .[] | .[1]) as $miny
  | max( .[] | .[1]) as $maxy
  | (($maxx-$minx)|length) as $width
  | (($maxy-$miny)|length) as $height
  | svg( $minx; $miny; $width; $height),
    polyline,
    "</svg>" ;

fibonacci_word_svg(22) # the Rust entry uses 22
