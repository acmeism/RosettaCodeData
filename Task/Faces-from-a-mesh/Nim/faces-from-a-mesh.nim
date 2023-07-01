import algorithm, strutils

type
  Perimeter = seq[int]
  Face = tuple[name: char; perimeter: Perimeter]
  Edge = tuple[first, last: int]

const None = -1   # No point.

#---------------------------------------------------------------------------------------------------

func isSame(p1, p2: Perimeter): bool =
  ## Return "true" if "p1" and "p2" represent the same face.

  if p1.len != p2.len: return false

  for p in p1:
    if p notin p2: return false

  var start = p2.find(p1[0])
  if p1 == p2[start..^1] & p2[0..<start]:
    return true

  let p3 = reversed(p2)
  start = p3.find(p1[0])
  if p1 == p3[start..^1] & p3[0..<start]:
    return true

#---------------------------------------------------------------------------------------------------

func `$`(perimeter: Perimeter): string =
  ## Convert a perimeter to a string.
  '(' & perimeter.join(", ") & ')'

func `$`(face: Face): string =
  ## Convert a perimeter formatted face to a string.
  face.name & $face.perimeter

#---------------------------------------------------------------------------------------------------

func toPerimeter(edges: seq[Edge]): Perimeter =
  ## Convert a list of edges to perimeter representation.
  ## Return an empty perimeter if the list of edges doesn’t represent a face.

  var edges = edges
  let firstEdge = edges.pop()       # First edge taken in account.
  var nextPoint = firstEdge.first   # Next point to search in remaining edges.
  result.add(nextpoint)

  while edges.len > 0:
    # Search an edge.
    var idx = None
    for i, e in edges:
      if e.first == nextPoint or e.last == nextPoint:
        idx = i
        nextPoint = if nextpoint == e.first: e.last else: e.first
        break
    if idx == None:
      return @[]      # No edge found containing "newPoint".

    # Add next point to perimeter and remove the edge.
    result.add(nextPoint)
    edges.del(idx)

  # Check that last added point is the expected one.
  if nextPoint != firstEdge.last:
    return @[]

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  # List of pairs of perimeter formatted faces to compare.
  const FP = [(('P', @[8, 1, 3]), ('R', @[1, 3, 8])),
              (('U', @[18, 8, 14, 10, 12, 17, 19]), ('V', @[8, 14, 10, 12, 17, 19, 18]))]

  echo "Perimeter comparison:"
  for (p1, p2) in FP:
    echo p1, if isSame(p1[1], p2[1]): " is same as " else: "is not same as", p2

  # List of edge formatted faces.
  const FE = {'E': @[(1, 11), (7, 11), (1, 7)],
              'F': @[(11, 23), (1, 17), (17, 23), (1, 11)],
              'G': @[(8, 14), (17, 19), (10, 12), (10, 14), (12, 17), (8, 18), (18, 19)],
              'H': @[(1, 3), (9, 11), (3, 11), (1, 11)]}

  echo ""
  echo "Conversion from edge to perimeter format:"
  for (faceName, edges) in FE:
    let perimeter = edges.toPerimeter()
    echo faceName, ": ", if perimeter.len == 0: "Invalid edge list" else: $perimeter
