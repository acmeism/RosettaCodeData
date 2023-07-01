# Input: [x, y]
def mult($a; $b): [.[0]*$a, .[1]*$b] ;

# Input: a number
def round($n): . * $n | floor / $n;

# svg header boilerplate
def svg($h; $w):
  "<?xml version='1.0' standalone='no'?>",
  "<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN' 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>",
  "<svg height='\($h)' width='\($w)' version='1.1' xmlns='http://www.w3.org/2000/svg'>";
</syntaxhighlight�>
'''Superellipse functions'''
<syntaxhighlight lang=jq>
# y in terms of x
# input: {a,b,n}
def y($x): (.b *  pow( (1 - pow( ($x/.a)|length ; .n) ) ; 1/.n )) | round(10);

# input: {a,b,n}
def pline(q):
  "<polyline points='\(q|map(join(","))|join(" "))'",
  " style='fill:none; stroke:black; stroke-width:3' transform='translate(\(.a + 10), \(.b + 10))' />";

# input: {a,b,n}
def plot:
  # points for one quadrant
  [range(0;400) as $i | [$i, y($i)] | select(.[1] | isnan | not) ] as $q
  |
    pline($q),
    pline($q | map( mult(1;-1))),  # flip and mirror
    pline($q | map( mult(-1;-1))), # for the other
    pline($q | map( mult(-1;1)))   # three quadrants
;

# Input: {a,b,n} - the constants for the superellipse
def superellipse:
  svg(.b*2 + 10; .a*2 + 10), plot, "</svg>";

{ a: 200,  b: 200,  n: 2.5 }
| superellipse
