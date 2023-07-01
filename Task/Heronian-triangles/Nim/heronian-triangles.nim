import std/[math, algorithm, lenientops, strformat, sequtils]

type HeronianTriangle = tuple[a, b, c: int; p: int; area: int]

# Functions with three operands.
func max(a, b, c: int): int = max(a, max(b, c))
func gcd(a, b, c: int): int = gcd(a, gcd(b, c))

func cmp(x, y: HeronianTriangle): int =
  ## Compare two Heronian triangles.
  result = cmp(x.area, y.area)
  if result == 0:
    result = cmp(x.p, y.p)
    if result == 0:
      result = cmp(max(x.a, x.b, x.c), max(y.a, y.b, y.c))

func `$`(t: HeronianTriangle): string =
  ## Return the representation of a Heronian triangle.
  fmt"{t.a:3d}, {t.b:3d}, {t.c:3d} {t.p:7d} {t.area:8d}"


func hero(a, b, c: int): float =
  ## Return the area of a triangle using Hero's formula.
  let s = (a + b + c) / 2
  result = sqrt(s * (s - a) * (s - b) * (s - c))

func isHeronianTriangle(x: float): bool = x > 0 and ceil(x) == x

const Header = "    Sides      Perimeter  Area\n-------------  ---------  ----"

var list: seq[HeronianTriangle]
const Max = 200

for c in 1..Max:
  for b in 1..c:
    for a in 1..b:
      let area = hero(a, b, c)
      if area.isHeronianTriangle and gcd(a, b, c) == 1:
        let t: HeronianTriangle = (a, b, c, a + b + c, area.toInt)
        list.add t

list.sort(cmp)
echo "Number of Heronian triangles: ", list.len

echo "\nOrdered list of first ten Heronian triangles:"
echo Header
for t in list[0 ..< 10]: echo t

echo "\nOrdered list of Heronian triangles with area 210:"
echo Header
for t in list.filterIt(it.area == 210): echo t
