# A Point is represented by a JSON array: [x, y, group]

def hugeVal: infinite;

def RAND_MAX : 1000;

def PTS: $PTS;
def K :   6;
def W : 400;
def H : 400;

def rand: input | tonumber;
def randf(m): m * rand / (RAND_MAX - 1);

def pi: 1 | atan * 4;

# Pseudo-randomly generate `count` points in a circle with the given radius
def genXY(count; radius):
  # note: this is not a uniform 2-d distribution
  pi as $pi
  | reduce range(0; count) as $i ([];
      .[$i] = [0, 0, 0]
      | randf(2 * $pi) as $ang
      | randf(radius) as $r
      | .[$i][0] = $r * ($ang|cos)
      | .[$i][1] = $r * ($ang|sin) ) ;

def dist2($a; $b):
  ($a[0] - $b[0]) as $x
  | ($a[1] - $b[1]) as $y
  | $x * $x + $y * $y;

# output: {minD, minI}
def nearest($pt; $cent; $nCluster):
  { minD : hugeVal,
    minI : $pt[2] }
  | reduce range(0; $nCluster) as $i (.;
      dist2($cent[$i]; $pt) as $d
      | if .minD > $d
        then .minD = $d
        | .minI = $i
        else .
        end ) ;

# input: {pts, cent}
# output: ditto
def kpp(len):
  (.cent|length) as $nCent
  | .cent[0] = .pts[rand % len]
  | . + { d: []}
  | reduce range(1; $nCent) as $nCluster (.;
      .sum = 0
      | reduce range(0; len) as $j (.;
          .d[$j] = nearest(.pts[$j]; .cent; $nCluster).minD
          | .sum += .d[$j] )
      | .sum = randf(.sum)
      | label $out
      | .emit = null
      # Be sure to emit something:
      | foreach (range(0; len), null) as $j (.;
          if $j == null then .emit = .
          else .sum -= .d[$j]
          | if .sum > 0
            then .
            else .cent[$nCluster] = .pts[$j]
            | .emit = .
            end
          end;
          select(.emit) | (.emit, break $out)
     ) )
  | reduce range(0; len) as $j (.;
      .pts[$j][2] = nearest(.pts[$j]; .cent; $nCent).minI ) ;

# Input: an array of Point (.pts)
# Output: {pts, cent}
def lloyd(len; nCluster):
  {pts: .,
   cent: [range(0; nCluster) | [0,0,0]]}
  | kpp(len)

  # stop when > 99.9% of points are good
  | until( .changed > (len / 1E4);

      # group elements of centroids are used as counters
      reduce range(0; nCluster) as $i (.; .cent[$i] = [0,0,0])
      | reduce range(0; len) as $j (.;
          .pts[$j] as $p
          | .cent[$p[2]] |= [ .[0]+$p[0], .[1]+$p[1], .[2] + 1] )
      | reduce range(0; nCluster) as $i (.;
          (.cent[$i][2] | if . == 0 then 0.0001 else . end) as $divisor
          | .cent[$i] |= [ (.[0]/$divisor), (.[1]/$divisor), .[2] ] )
      | .changed = 0
      # find closest centroid of each point
      | reduce range(0; len) as $j (.;
          .pts[$j] as $p
          | nearest($p; .cent; nCluster).minI as $minI
          | if $minI != $p[2]
            then .changed += 1
            | .pts[$j][2] = $minI
            else .
            end) )
  | .cent |= reduce range(0; nCluster) as $i (.; .[$i][2] = $i ) ;

def printEps($pts; len; cent; nCluster):

  def f1($x;$y;$z): "\($x) \($y) \($z) setrgbcolor";
  def f2($x;$y)  : "\($x) \($y) c";
  def f3($x;$y)  : "\n0 setgray \($x) \($y) s";

  def colors:
    reduce range(0; nCluster) as $i ([];
        .[3 * $i + 0] = (3 * ($i + 1) % 11) / 11
      | .[3 * $i + 1] = (7 * $i % 11) / 11
      | .[3 * $i + 2] = (9 * $i % 11) / 11 );

  {colors: colors}
  | .minX = hugeVal
  | .minY = hugeVal
  | .maxX = -hugeVal
  | .maxY = -hugeVal
  | reduce range(0; len) as $j (.;
      $pts[$j] as $p
      | if .maxX < $p[0] then .maxX = $p[0] else . end
      | if .minX > $p[0] then .minX = $p[0] else . end
      | if .maxY < $p[1] then .maxY = $p[1] else . end
      | if .minY > $p[1] then .minY = $p[1] else . end )
  | ([((W / (.maxX - .minX))), ((H / (.maxY - .minY)))] | min) as $scale
  | ( (.maxX + .minX) / 2) as $cx
  | ( (.maxY + .minY) / 2) as $cy

  | "%!PS-Adobe-3.0\n%%BoundingBox: -5 -5 \(W + 10) \(H + 10)",
    "/l {rlineto} def /m {rmoveto} def",
    "/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def",
    "/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath ",
    "     gsave 1 setgray fill grestore gsave 3 setlinewidth",
    " 1 setgray stroke grestore 0 setgray stroke }def",
    (range(0; nCluster) as $i
     | cent[$i] as $c
     |  f1(.colors[3 * $i]; .colors[3 * $i + 1]; .colors[3 * $i + 2]),
        ( range(0; len) as $j
          | $pts[$j] as $p
          | if $p[2] == $i
            then f2( ($p[0] - $cx) * $scale + W / 2; ($p[1] - $cy) * $scale + H / 2)
            else empty
            end ),
        f3( ($c[0] - $cx) * $scale + W / 2; ($c[1] - $cy) * $scale + H / 2)),
    "\n%%EOF"
;

# The required clustering function with two arguments.
# It returns {pts, cent}
# where .pts and .cent are arrays of Points,
# with the cluster id as the third item.
#
def cluster($nCluster; $points):
  $points
  | lloyd( length; $nCluster);

# The task:
genXY(PTS; 10)
| lloyd(PTS; K) as { pts: $pts, cent: $cent }
| printEps($pts; PTS; $cent; K)
