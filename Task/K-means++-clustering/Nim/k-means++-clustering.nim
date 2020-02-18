#
# compile:
#   nim c -d:release kmeans.nim
#
# and pipe the resultant EPS output to a file, e.g.
#
#   kmeans > results.eps
#
import random, math, strutils

const
  FloatMax  = 1.0e100
  nPoints   = 100_000
  nClusters = 11

type
  Point = object
    x, y: float
    group: int
  Points = seq[Point]
  ClusterDist = tuple[indx: int, dist: float]
  ColorRGB = tuple[r, g, b: float]

proc generatePoints(nPoints: int, radius: float): Points =
  result.setLen(nPoints)
  for i in 0..<nPoints:
    let
      r = rand(1.0) * radius
      ang = rand(1.0) * 2 * PI
    result[i] = Point(x: r * cos(ang),
                      y: r * sin(ang),
                      group: 0)

proc nearestClusterCenter(point: Point, cluster_centers: Points): ClusterDist =
  # Distance and index of the closest cluster center
  proc sqrDistance2D(a, b: Point): float =
    result = (a.x - b.x) ^ 2  +  (a.y - b.y) ^ 2

  result = (indx: point.group, dist: FLOAT_MAX)

  for i, cc in pairs(cluster_centers):
    let d = sqrDistance2D(cc, point)
    if result.dist > d:
      result.dist = d
      result.indx = i

proc kpp(points: var Points, clusterCenters: var Points) =
  let
    choice = points[rand(points.high)]
  clusterCenters[0] = choice

  var
    d: seq[float]
    sum = 0.0

  d.setLen(points.len)

  for i in 1..clusterCenters.high:
    sum = 0.0
    for j, p in pairs(points):
      d[j] = nearestClusterCenter(p, cluster_centers[0..i])[1]
      sum += d[j]

    sum *= rand(1.0)

    for j, di in pairs(d):
      sum -= di
      if sum > 0.0:
        continue
      clusterCenters[i] = points[j]
      break

  for _, p in mpairs(points):
    p.group = nearestClusterCenter(p, clusterCenters)[0]


proc lloyd(points: var Points, nclusters: int): Points =
  #result is the cluster_centers
  let lenpts10 = points.len shr 10
  var
    changed = 0
    minI = 0
  result.setLen(nclusters)

  # call k++ init
  kpp(points, result)

  while true:
    # group element for centroids are used as counters
    for _, cc in mpairs(result):
      cc.x = 0.0
      cc.y = 0.0
      cc.group = 0

    for p in points:
      let i = p.group
      result[i].group += 1
      result[i].x += p.x
      result[i].y += p.y

    for _, cc in mpairs(result):
      cc.x /= cc.group.float
      cc.y /= cc.group.float

    # find closest centroid of each PointPtr
    changed = 0

    for _, p in mpairs(points):
      minI = nearest_cluster_center(p, result)[0]
      if minI != p.group:
        changed += 1
        p.group = minI

    # stop when 99.9% of points are good
    if changed <= lenpts10:
      break

  for i, cc in mpairs(result):
      cc.group = i

proc printEps(points: Points, cluster_centers: Points, W: int = 400, H: int = 400) =
  var
    colors: seq[ColorRGB]

  colors.setLen(clusterCenters.len)

  #assert((3.0 * 5.0) mod 11.0 == 4.0)
  #assert(3.0 * 5.0 mod 11.0 == 4.0)
  #assert((3.0 * 5.0 mod 11.0) / 2.0 == 2.0)
  #assert(3.0 * 5.0 mod 11.0 / 2.0 == 2.0)

  for i in 0..<clusterCenters.len:
    let
      f1 = i.float
      f2 = (i + 1).float
    colors[i] = (r: (3.0 * f2) mod 11.0 / 11.0,
                 g: (7.0 * f1) mod 11.0 / 11.0,
                 b: (9.0 * f1) mod 11.0 / 11.0 )

  var
    max_x = -FLOAT_MAX
    max_y = -FLOAT_MAX
    min_x =  FLOAT_MAX
    min_y =  FLOAT_MAX

  for p in points:
    if max_x < p.x: max_x = p.x
    if min_x > p.x: min_x = p.x
    if max_y < p.y: max_y = p.y
    if min_y > p.y: min_y = p.y

  let
    scale = min(W.float / (max_x - min_x),
              H.float / (max_y - min_y))
    cx = (max_x + min_x) / 2.0
    cy = (max_y + min_y) / 2.0

  echo "%!PS-Adobe-3.0\n%%BoundingBox: -5 -5 $1 $2" % [$(W + 10), $(H + 10)]

  echo """/l {rlineto} def /m {rmoveto} def
/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def
/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath
   gsave 1 setgray fill grestore gsave 3 setlinewidth
 1 setgray stroke grestore 0 setgray stroke }def"""

  for i, cc in pairs(clusterCenters):
    echo "$1 $2 $3 setrgbcolor" %
            [formatFloat(colors[i].r, ffDecimal, 6),
             formatFloat(colors[i].g, ffDecimal, 6),
             formatFloat(colors[i].b, ffDecimal, 6)]

    for p in points:
      if p.group != i:
        continue
      echo "$1 $2 c" % [formatFloat( ((p.x - cx) * scale + W / 2), ffDecimal, 3),
                        formatFloat( ((p.y - cy) * scale + H / 2), ffDecimal, 3)]

    echo "\n0 setgray $1 $2 s" % [formatFloat( ((cc.x - cx) * scale + W / 2), ffDecimal, 3),
                                  formatFloat( ((cc.y - cy) * scale + H / 2), ffDecimal, 3)]

  echo "\nshowpage\n%%EOF"


proc main() =
  randomize()

  var
    points = generatePoints(nPoints, 10.0)
  let
    clusterCentrs = lloyd(points, nClusters)
  printEps(points, clusterCentrs)

main()
