import algorithm, sequtils, strutils, sugar

type Point = tuple[x, y: int]

func rotate90(p: Point): Point = (p.y, -p.x)
func rotate180(p: Point): Point = (-p.x, -p.y)
func rotate270(p: Point): Point = (-p.y, p.x)
func reflect(p: Point): Point = (-p.x, p.y)

func `$`(p: Point): string = "($1, $2)".format(p.x, p.y)


type Polyomino = seq[Point]

func minima(poly: Polyomino): (int, int) =
  ## Finds the min x and y coordinates of a polyomino.
  (min(poly.mapIt(it.x)), min(poly.mapIt(it.y)))

func translateToOrigin(poly: Polyomino): Polyomino =
  let (minX, minY) = poly.minima
  result = sorted(poly.mapIt((it.x - minX, it.y - minY)))

func rotationsAndReflections(poly: Polyomino): seq[Polyomino] =
  @[poly,
    poly.mapIt(it.rotate90),
    poly.mapIt(it.rotate180),
    poly.mapIt(it.rotate270),
    poly.mapIt(it.reflect),
    poly.mapIt(it.rotate90.reflect),
    poly.mapIt(it.rotate180.reflect),
    poly.mapIt(it.rotate270.reflect)]

func canonical(poly: Polyomino): Polyomino =
  sortedByIt(poly.rotationsAndReflections.map(translateToOrigin), $it)[0]

func contiguous(p: Point): array[4, Point] =
  # Return all four points in Von Neumann neighborhood.
  [(p.x - 1, p.y), (p.x + 1, p.y), (p.x, p.y - 1), (p.x, p.y + 1)]

func newPoints(poly: Polyomino): seq[Point] =
  ## Return all distinct points that can be added to a Polyomino.
  result = collect(newSeq):
             for point in poly:
               for pt in point.contiguous():
                 if pt notin poly: pt
  result = result.deduplicate()

func newPolys(poly: Polyomino): seq[Polyomino] =
  collect(newSeq, for pt in poly.newPoints: canonical(poly & pt))

const Monominoes = @[@[(x: 0, y: 0)]]

func rank(n: Natural): seq[Polyomino] =
  if n == 0: return newSeq[Polyomino]()
  if n == 1: return Monominoes
  result = collect(newSeq):
             for poly in rank(n - 1):
               for p in poly.newPolys(): p
  result = sortedByIt(result, $it).deduplicate(true)

when isMainModule:

  let n = 5
  echo "All free polyominoes of rank $#:\n".format(n)
  for poly in rank(n): echo poly.join(" ")

  let k = 10
  echo "\nNumber of free polyominoes of ranks 1 to $#:".format(k)
  for i in 1..k: stdout.write rank(i).len, ' '
  echo()
