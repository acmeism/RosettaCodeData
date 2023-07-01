import algorithm
import tables

const None = -1   # Index number used to indicate no data.

type

  Point = array[3, float]
  Face = seq[int]

  Edge = object
    pn1: int    # Point number 1.
    pn2: int    # Point number 2.
    fn1: int    # Face number 1.
    fn2: int    # Face number 2.
    cp: Point   # Center point.

  PointEx = object
    p: Point
    n: int

  PointNums = tuple[pn1, pn2: int]


####################################################################################################
# Point operations.

func `+`(p1, p2: Point): Point =
  ## Adds points p1 and p2.
  for i in 0..Point.high:
    result[i] = p1[i] + p2[i]

#---------------------------------------------------------------------------------------------------

func `*`(p: Point; m: float): Point =
  ##  Multiply point p by m.
  for i in 0..Point.high:
    result[i] = p[i] * m

#---------------------------------------------------------------------------------------------------

func `/`(p: Point; d: float): Point =
  ## Divide point p by d.
  for i in 0..Point.high:
    result[i] = p[i] / d

#---------------------------------------------------------------------------------------------------

func centerPoint(p1, p2: Point): Point =
  ## Return a point in the center of the segment ended by points p1 and p2.
  for i in 0..Point.high:
    result[i] = (p1[i] + p2[i]) / 2


####################################################################################################

func getFacePoints(inputPoints: seq[Point]; inputFaces: seq[Face]): seq[Point] =
  ## For each face, a face point is created which is the average of all the points of the face.

  result.setLen(inputFaces.len)
  for i, currFace in inputFaces:
    var facePoint: Point
    for currPointIndex in currFace:
      # Add currPoint to facePoint. Will divide later.
      facePoint = facePoint + inputPoints[currPointIndex]
    result[i] = facePoint / currFace.len.toFloat

#---------------------------------------------------------------------------------------------------

func getEdgesFaces(inputPoints: seq[Point]; inputFaces: seq[Face]): seq[Edge] =
  ## Get list of edges and the one or two adjacent faces in a list.
  ## Also get center point of edge.

  # Get edges for each face.
  var edges: seq[array[3, int]]
  for faceNum, face in inputFaces:
    # Loop over index into face.
    for pointIndex in 0..face.high:
      # If not last point then edge is current point and next point
      # and for last point, edge is current point and first point.
      var pointNum1 = face[pointIndex]
      var pointNum2 = if pointIndex < face.high: face[pointIndex + 1] else: face[0]
      # Order points in edge by lowest point number.
      if pointNum1 > pointNum2:
        swap pointNum1, pointNum2
      edges &= [pointNum1, pointNum2, faceNum]

  # Sort edges by pointNum1, pointNum2, faceNum.
  edges.sort(proc(a1, a2: array[3, int]): int =
                  result = cmp(a1[0], a2[0])
                  if result == 0:
                    result = cmp(a1[1], a2[1])
                    if result == 0:
                      result = cmp(a1[2], a2[2]))

  # Merge edges with 2 adjacent faces:
  # [pointNum1, pointNum2, faceNum1, faceNum2] or
  # [pointNum1, pointNum2, faceNum1, None]
  var eIndex = 0
  var mergedEdges: seq[array[4, int]]
  while eIndex < edges.len:
    let e1 = edges[eIndex]
    # Check if not last edge.
    if eIndex < edges.high:
      let e2 = edges[eIndex + 1]
      if e1[0] == e2[0] and e1[1] == e2[1]:
        mergedEdges &= [e1[0], e1[1], e1[2], e2[2]]
        inc eIndex, 2
      else:
        mergedEdges &= [e1[0], e1[1], e1[2], None]
        inc eIndex
    else:
      mergedEdges &= [e1[0], e1[1], e1[2], None]
      inc eIndex

  # Add edge centers.
  for me in mergedEdges:
    let p1 = inputPoints[me[0]]
    let p2 = inputPoints[me[1]]
    let cp = centerPoint(p1, p2)
    result.add(Edge(pn1: me[0], pn2: me[1], fn1: me[2], fn2: me[3], cp: cp))

#---------------------------------------------------------------------------------------------------

func getEdgePoints(inputPoints: seq[Point];
                   edgesFaces: seq[Edge];
                   facePoints: seq[Point]): seq[Point] =
  ## For each edge, an edge point is created which is the average between the center of the
  ## edge and the center of the segment made with the face points of the two adjacent faces.

  result.setLen(edgesFaces.len)
  for i, edge in edgesFaces:
    # Get center of two facepoints.
    let fp1 = facePoints[edge.fn1]
    # If not two faces, just use one facepoint (should not happen for solid like a cube).
    let fp2 = if edge.fn2 == None: fp1 else: facePoints[edge.fn2]
    let cfp = centerPoint(fp1, fp2)
    # Get average between center of edge and center of facePoints.
    result[i] = centerPoint(edge.cp, cfp)

#---------------------------------------------------------------------------------------------------

func getAvgFacePoints(inputPoints: seq[Point];
                      inputFaces: seq[Face];
                      facePoints: seq[Point]): seq[Point] =
    ## For each point calculate the average of the face points of the faces the
    ## point belongs to (avgFacePoints), create a list of lists of two numbers
    ## [facePointSum, numPoints] by going through the points in all the faces then
    ## create the avgFacePoints list of point by dividing pointSum(x, y, z) by numPoints

    var tempPoints = newSeq[PointEx](inputPoints.len)

    # Loop through faces, updating tempPoints.
    for faceNum, pointNums in inputFaces:
      let fp = facePoints[faceNum]
      for pointNum in pointNums:
        let tp = tempPoints[pointNum].p
        tempPoints[pointNum].p = tp + fp
        inc tempPoints[pointNum].n

    # Divide to build the result.
    result.setLen(inputPoints.len)
    for i, tp in tempPoints:
      result[i] = tp.p / tp.n.toFloat

#---------------------------------------------------------------------------------------------------

func getAvgMidEdges(inputPoints: seq[Point]; edgesFaces: seq[Edge]): seq[Point] =
  ## Return the average of the centers of edges the point belongs to (avgMidEdges).
  ## Create list with entry for each point. Each entry has two elements. One is a point
  ## that is the sum of the centers of the edges and the other is the number of edges.
  ## After going through all edges divide by number of edges.

  var tempPoints = newSeq[PointEx](inputPoints.len)

  # Go through edgesFaces using center updating each point.
  for edge in edgesFaces:
    for pointNum in [edge.pn1, edge.pn2]:
      let tp = tempPoints[pointNum].p
      tempPoints[pointNum].p = tp + edge.cp
      inc tempPoints[pointNum].n

    # Divide out number of points to get average.
    result.setLen(inputPoints.len)
    for i, tp in tempPoints:
      result[i] = tp.p / tp.n.toFloat

#---------------------------------------------------------------------------------------------------

func getPointsFaces(inputPoints: seq[Point]; inputFaces: seq[Face]): seq[int] =
  # Return the number of faces for each point.

  result.setLen(inputPoints.len)

  # Loop through faces updating the result.
  for pointNums in inputFaces:
    for pointNum in pointNums:
      inc result[pointNum]

#---------------------------------------------------------------------------------------------------

func getNewPoints(inputPoints: seq[Point]; pointsFaces: seq[int];
                  avgFacePoints, avgMidEdges: seq[Point]): seq[Point] =
  ## m1 = (n - 3.0) / n
  ## m2 = 1.0 / n
  ## m3 = 2.0 / n
  ## newCoords = (m1 * oldCoords) + (m2 * avgFacePoints) + (m3 * avgMidEdges)

  result.setLen(inputPoints.len)
  for pointNum, oldCoords in inputPoints:
    let n = pointsFaces[pointNum].toFloat
    let (m1, m2, m3) = ((n - 3) / n, 1 / n, 2 / n)
    let p1 = oldCoords * m1
    let afp = avgFacePoints[pointNum]
    let p2 = afp * m2
    let ame = avgMidEdges[pointNum]
    let p3 = ame * m3
    let p4 = p1 + p2
    result[pointNum] = p4 + p3

#---------------------------------------------------------------------------------------------------

func switchNums(pointNums: PointNums): PointNums =
  ## Return tuple of point numbers sorted least to most.

  if pointNums.pn1 < pointNums.pn2: pointNums
  else: (pointNums.pn2, pointNums.pn1)

#---------------------------------------------------------------------------------------------------

func cmcSubdiv(inputPoints: seq[Point];
               inputFaces: seq[Face]): tuple[p: seq[Point], f: seq[Face]] =
  ## For each face, a face point is created which is the average of all the points of the face.
  ## Each entry in the returned list is a point (x, y, z).

  let facePoints = getFacePoints(inputPoints, inputFaces)
  let edgesFaces = getEdgesFaces(inputPoints, inputFaces)
  let edgePoints = getEdgePoints(inputPoints, edgesFaces, facePoints)
  let avgFacePoints = getAvgFacePoints(inputPoints, inputFaces, facePoints)
  let avgMidEdges = getAvgMidEdges(inputPoints, edgesFaces)
  let pointsFaces = getPointsFaces(inputPoints, inputFaces)
  var newPoints = getNewPoints(inputPoints, pointsFaces, avgFacePoints, avgMidEdges)

  #[Then each face is replaced by new faces made with the new points,

    for a triangle face (a,b,c):
       (a, edgePoint ab, facePoint abc, edgePoint ca)
       (b, edgePoint bc, facePoint abc, edgePoint ab)
       (c, edgePoint ca, facePoint abc, edgePoint bc)

    for a quad face (a,b,c,d):
       (a, edgePoint ab, facePoint abcd, edgePoint da)
       (b, edgePoint bc, facePoint abcd, edgePoint ab)
       (c, edgePoint cd, facePoint abcd, edgePoint bc)
       (d, edgePoint da, facePoint abcd, edgePoint cd)

    facePoints is a list indexed by face number so that is easy to get.

    edgePoints is a list indexed by the edge number which is an index into edgesFaces.

    Need to add facePoints and edgePoints to newPoints and get index into each.

    Then create two new structures:

    facePointNums: list indexes by faceNum whose value is the index into newPoints.

    edgePointNums: dictionary with key (pointNum1, pointNum2) and value is index into newPoints.
  ]#

  # Add face points to newPoints.
  var facePointNums: seq[int]
  var nextPointNum = newPoints.len    # PointNum after next append to newPoints.
  for facePoint in facePoints:
    newPoints.add(facePoint)
    facePointNums.add(nextPointNum)
    inc nextPointNum

  # Add edge points to newPoints.
  var edgePointNums: Table[tuple[pn1, pn2: int], int]
  for edgeNum, edgesFace in edgesFaces:
    let pointNum1 = edgesFace.pn1
    let pointNum2 = edgesFace.pn2
    newPoints.add(edgePoints[edgeNum])
    edgePointNums[(pointNum1, pointNum2)] = nextPointNum
    inc nextPointNum

  # newPoints now has the points to output. Need new faces.

  #[Just doing this case for now:

    for a quad face (a,b,c,d):
       (a, edgePoint ab, facePoint abcd, edgePoint da)
       (b, edgePoint bc, facePoint abcd, edgePoint ab)
       (c, edgePoint cd, facePoint abcd, edgePoint bc)
       (d, edgePoint da, facePoint abcd, edgePoint cd)

    newFaces will be a list of lists where the elements are like this:
    [pointNum1, pointNum2, pointNum3, pointNum4]
  ]#

  var newFaces: seq[Face]
  for oldFaceNum, oldFace in inputFaces:
    # 4 points face.
    if oldFace.len == 4:
      let (a, b, c, d) = (oldFace[0], oldface[1], oldface[2], oldface[3])
      let facePointAbcd = facePointNums[oldFaceNum]
      let edgePointAb = edgePointNums[switchNums((a, b))]
      let edgePointDa = edgePointNums[switchNums((d, a))]
      let edgePointBc = edgePointNums[switchNums((b, c))]
      let edgePointCd = edgePointNums[switchNums((c, d))]
      newFaces &= @[a, edgePointAb, facePointAbcd, edgePointDa]
      newFaces &= @[b, edgePointBc, facePointAbcd, edgePointAb]
      newFaces &= @[c, edgePointCd, facePointAbcd, edgePointBc]
      newFaces &= @[d, edgePointDa, facePointAbcd, edgePointCd]

    result = (newPoints, newFaces)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import strformat, strutils

  let inputPoints = @[[-1.0, 1.0, 1.0],
                      [-1.0, -1.0, 1.0],
                      [1.0, -1.0, 1.0],
                      [1.0, 1.0, 1.0],
                      [1.0, -1.0, -1.0],
                      [1.0, 1.0, -1.0],
                      [-1.0, -1.0, -1.0],
                      [-1.0, 1.0, -1.0]]

  let inputFaces = @[@[0, 1, 2, 3],
                     @[3, 2, 4, 5],
                     @[5, 4, 6, 7],
                     @[7, 0, 3, 5],
                     @[7, 6, 1, 0],
                     @[6, 1, 2, 4]]

  var outputPoints = inputPoints
  var outputFaces = inputFaces
  const Iterations = 1

  for i in 1..Iterations:
    (outputPoints, outputFaces) = cmcSubdiv(outputPoints, outputFaces)

  for p in outputPoints:
    echo fmt"[{p[0]: .4f}, {p[1]: .4f}, {p[2]: .4f}]"
  echo ""
  for nums in outputFaces:
    var s = "["
    for n in nums:
      s.addSep(", ", 1)
      s.add(fmt"{n:2d}")
    s.add(']')
    echo s
