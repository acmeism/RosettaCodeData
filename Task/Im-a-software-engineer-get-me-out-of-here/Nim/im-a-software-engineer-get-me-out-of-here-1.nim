import std/[sequtils, strformat, strutils]

const Gmooh = """
.........00000.........
......00003130000......
....000321322221000....
...00231222432132200...
..0041433223233211100..
..0232231612142618530..
.003152122326114121200.
.031252235216111132210.
.022211246332311115210.
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
.013322444412122123210.
.015132331312411123120.
.003333612214233913300.
..0219126511415312570..
..0021321524341325100..
...00211415413523200...
....000122111322000....
......00001120000......
.........00000.........""".split("\n")

const
  Width  = Gmooh[0].len
  Height = Gmooh.len

type
  Pyx = tuple[y, x: int]
  Route = tuple[cost, fromy, fromx: int]
  Routes = seq[seq[Route]]

const D: array[8, Pyx] = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]

const ZeroRoute: Route = (0, 0, 0)
var routes: Routes    # Route for each Gmooh[][].

proc `$`(pyx: Pyx): string =
  &"({pyx.y}, {pyx.x})"

proc `$`(pyxSeq: seq[Pyx]): string =
  result = "["
  for pyx in pyxSeq:
    result.addSep(startLen = 2)
    result.add $pyx
  result.add ']'

func search(routes: var Routes; y, x: int) =
  ## Simple breadth-first search, populates "routes".
  ## This isn't strictly Dijkstra because graph edges are not weighted.
  var x = x
  var y = y
  var cost = 0
  routes = newSeqWith(Height, newSeq[Route](Width))
  routes[y][x] = (0, y, x)  # Zero-cost, the starting point.
  var next: seq[Route]
  while true:
    var n = ord(Gmooh[y][x]) - ord('0')
    for (dy, dx) in D:
      let rx = x + n * dx
      let ry = y + n * dy
      if rx >= 0 and rx < Width and ry >= 0 and ry < Height and Gmooh[ry][rx] >= '0':
        let ryx = routes[ry][rx]
        if ryx == ZeroRoute or ryx.cost > cost + 1:
          routes[ry][rx] = (cost + 1, y, x)
          if Gmooh[ry][rx] > '0':
            next.add (cost + 1, ry, rx)
            # If the graph was weighted, at this point
            # that would get shuffled up into place.
    if next.len == 0: break
    (cost, y, x) = next[0]
    next.delete 0

func getRoute(routes: Routes; yx: Pyx): seq[Pyx] =
  var (y, x) = yx
  var cost: int
  result = @[yx]
  while true:
    (cost, y, x) = routes[y][x]
    if cost == 0: break
    result.insert (y, x)

proc showShortest(routes: Routes) =
  var shortest = 9999
  var res: seq[Pyx]
  for x in 0..<Width:
    for y in 0..<Height:
      if Gmooh[y][x] == '0':
        let ryx = routes[y][x]
        if ryx != ZeroRoute:
          let cost = ryx.cost
          if cost <= shortest:
            if cost < shortest:
              res.reset()
              shortest = cost
            res.add (y, x)
  let (areis, s) = if res.len > 1: ("are", "s") else: ("is", "")
  echo &"There {areis} {res.len} shortest route{s}] of {shortest} days to safety:"
  for r in res:
    echo routes.getRoute(r)

proc showUnreachable(routes: Routes) =
  var res: seq[Pyx]
  for x in 0..<Width:
    for y in 0..<Height:
      if Gmooh[y][x] >= '0' and routes[y][x] == ZeroRoute:
        res.add (y, x)
  echo "\nThe following cells are unreachable:"
  echo res

proc showLongest(routes: Routes) =
  var longest = 0
  var res: seq[Pyx]
  for x in 0..<Width:
    for y in 0..<Height:
      if Gmooh[y][x] >= '0':
        var ryx = routes[y][x]
        if ryx != ZeroRoute:
          var rl = ryx.cost
          if rl >= longest:
            if rl > longest:
              res.reset()
              longest = rl
            res.add (y, x)
  echo &"\nThere are {res.len} cells that take {longest} days to send reinforcements to:"
  for r in res:
    echo routes.getRoute(r)

routes.search(11, 11)
routes.showShortest()

routes.search(21, 11)
echo "\nThe shortest route from [21,11] to [1,11]:"
echo routes.getRoute((1, 11))

routes.search(1, 11)
echo "\nThe shortest route from [1,11] to [21,11]:"
echo routes.getRoute((21, 11))

routes.search(11, 11)
routes.showUnreachable()
routes.showLongest()
