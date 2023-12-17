import "./dynamic" for Tuple, Struct
import "./sort" for Sort
import "./math" for Int
import "./fmt" for Fmt

var Point = Tuple.create("Point", ["x", "y", "z"])
var fields = [
    "pn1",  // point number 1
    "pn2",  // point number 2
    "fn1",  // face number 1
    "fn2",  // face number 2
    "cp"    // center point
]
var Edge  = Tuple.create("Edge", fields)
var PointEx = Struct.create("PointEx", ["p", "n"])

var sumPoint = Fn.new { |p1, p2| Point.new(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z) }

var mulPoint = Fn.new { |p, m| Point.new(p.x * m, p.y * m, p.z * m) }

var divPoint = Fn.new { |p, d| mulPoint.call(p, 1/d) }

var centerPoint = Fn.new { |p1, p2| divPoint.call(sumPoint.call(p1, p2), 2) }

var getFacePoints = Fn.new { |inputPoints, inputFaces|
    var facePoints = List.filled(inputFaces.count, null)
    var i = 0
    for (currFace in inputFaces) {
        var facePoint = Point.new(0, 0, 0)
        for (cpi in currFace) {
            var currPoint = inputPoints[cpi]
            facePoint = sumPoint.call(facePoint, currPoint)
        }
        facePoints[i] = divPoint.call(facePoint, currFace.count)
        i =  i + 1
    }
    return facePoints
}

var getEdgesFaces = Fn.new { |inputPoints, inputFaces|
    var edges = []
    var faceNum = 0
    for (face in inputFaces) {
        var numPoints = face.count
        for (pointIndex in 0...numPoints) {
            var pointNum1 = face[pointIndex]
            var pointNum2 = (pointIndex < numPoints-1) ? face[pointIndex+1] : face[0]
            if (pointNum1 > pointNum2) {
                var t = pointNum1
                pointNum1 = pointNum2
                pointNum2 = t
            }
            edges.add([pointNum1, pointNum2, faceNum])
        }
        faceNum = faceNum + 1
    }
    var cmp = Fn.new { |e1, e2|
        if (e1[0] == e2[0]) {
            if (e1[1] == e2[1]) return (e1[2] - e2[2]).sign
            return (e1[1] - e2[1]).sign
        }
        return (e1[0] - e2[0]).sign
    }
    var numEdges = edges.count
    Sort.quick(edges, 0, numEdges-1, cmp)
    var eIndex = 0
    var mergedEdges = []
    while (eIndex < numEdges) {
        var e1 = edges[eIndex]
        if (eIndex < numEdges-1) {
            var e2 = edges[eIndex+1]
            if (e1[0] == e2[0] && e1[1] == e2[1]) {
                mergedEdges.add([e1[0], e1[1], e1[2], e2[2]])
                eIndex = eIndex + 2
            } else {
                mergedEdges.add([e1[0], e1[1], e1[2], -1])
                eIndex = eIndex + 1
            }
        } else {
            mergedEdges.add([e1[0], e1[1], e1[2], -1])
            eIndex = eIndex + 1
        }
    }
    var edgesCenters = []
    for (me in mergedEdges) {
        var p1 = inputPoints[me[0]]
        var p2 = inputPoints[me[1]]
        var cp = centerPoint.call(p1, p2)
        edgesCenters.add(Edge.new(me[0], me[1], me[2], me[3], cp))
    }
    return edgesCenters
}

var getEdgePoints = Fn.new { |inputPoints, edgesFaces, facePoints|
    var edgePoints = List.filled(edgesFaces.count, null)
    var i = 0
    for (edge in edgesFaces) {
        var cp = edge.cp
        var fp1 = facePoints[edge.fn1]
        var fp2 = (edge.fn2 == -1) ? fp1 : facePoints[edge.fn2]
        var cfp = centerPoint.call(fp1, fp2)
        edgePoints[i] = centerPoint.call(cp, cfp)
        i = i + 1
    }
    return edgePoints
}

var getAvgFacePoints = Fn.new { |inputPoints, inputFaces, facePoints|
    var numPoints = inputPoints.count
    var tempPoints = List.filled(numPoints, null)
    for (i in 0...numPoints) tempPoints[i] = PointEx.new(Point.new(0, 0, 0), 0)
    for (faceNum in 0...inputFaces.count) {
        var fp = facePoints[faceNum]
        for (pointNum in inputFaces[faceNum]) {
            var tp = tempPoints[pointNum].p
            tempPoints[pointNum].p = sumPoint.call(tp, fp)
            tempPoints[pointNum].n = tempPoints[pointNum].n + 1
        }
    }
    var avgFacePoints = List.filled(numPoints, null)
    var i = 0
    for (tp in tempPoints) {
        avgFacePoints[i] = divPoint.call(tp.p, tp.n)
        i = i + 1
    }
    return avgFacePoints
}

var getAvgMidEdges = Fn.new { |inputPoints, edgesFaces|
    var numPoints = inputPoints.count
    var tempPoints = List.filled(numPoints, null)
    for (i in 0...numPoints) tempPoints[i] = PointEx.new(Point.new(0, 0, 0), 0)
    for (edge in edgesFaces) {
        var cp = edge.cp
        for (pointNum in [edge.pn1, edge.pn2]) {
            var tp = tempPoints[pointNum].p
            tempPoints[pointNum].p = sumPoint.call(tp, cp)
            tempPoints[pointNum].n = tempPoints[pointNum].n + 1
        }
    }
    var avgMidEdges = List.filled(tempPoints.count, null)
    var i = 0
    for (tp in tempPoints) {
        avgMidEdges[i] = divPoint.call(tp.p, tp.n)
        i = i + 1
    }
    return avgMidEdges
}

var getPointsFaces = Fn.new { |inputPoints, inputFaces|
    var numPoints = inputPoints.count
    var pointsFaces = List.filled(numPoints, 0)
    for (faceNum in 0...inputFaces.count) {
        for (pointNum in inputFaces[faceNum]) {
            pointsFaces[pointNum] = pointsFaces[pointNum] + 1
        }
    }
    return pointsFaces
}

var getNewPoints = Fn.new { |inputPoints, pointsFaces, avgFacePoints, avgMidEdges|
    var newPoints = List.filled(inputPoints.count, null)
    for (pointNum in 0...inputPoints.count) {
        var n = pointsFaces[pointNum]
        var m1 = (n-3) / n
        var m2 = 1 / n
        var m3 = 2 / n
        var oldCoords = inputPoints[pointNum]
        var p1 = mulPoint.call(oldCoords, m1)
        var afp = avgFacePoints[pointNum]
        var p2 = mulPoint.call(afp, m2)
        var ame = avgMidEdges[pointNum]
        var p3 = mulPoint.call(ame, m3)
        var p4 = sumPoint.call(p1, p2)
        newPoints[pointNum] = sumPoint.call(p4, p3)
    }
    return newPoints
}

var switchNums = Fn.new { |pointNums|
    if (pointNums[0] < pointNums[1]) return pointNums
    return [pointNums[1], pointNums[0]]
}

var cmcSubdiv = Fn.new { |inputPoints, inputFaces|
    var facePoints = getFacePoints.call(inputPoints, inputFaces)
    var edgesFaces = getEdgesFaces.call(inputPoints, inputFaces)
    var edgePoints = getEdgePoints.call(inputPoints, edgesFaces, facePoints)
    var avgFacePoints = getAvgFacePoints.call(inputPoints, inputFaces, facePoints)
    var avgMidEdges = getAvgMidEdges.call(inputPoints, edgesFaces)
    var pointsFaces = getPointsFaces.call(inputPoints, inputFaces)
    var newPoints = getNewPoints.call(inputPoints, pointsFaces, avgFacePoints, avgMidEdges)
    var facePointNums = []
    var nextPointNum = newPoints.count
    for (facePoint in facePoints) {
        newPoints.add(facePoint)
        facePointNums.add(nextPointNum)
        nextPointNum = nextPointNum + 1
    }
    var edgePointNums = {}
    for (edgeNum in 0...edgesFaces.count) {
        var pointNum1 = edgesFaces[edgeNum].pn1
        var pointNum2 = edgesFaces[edgeNum].pn2
        var edgePoint = edgePoints[edgeNum]
        newPoints.add(edgePoint)
        edgePointNums[Int.cantorPair(pointNum1, pointNum2)] = nextPointNum
        nextPointNum = nextPointNum + 1
    }
    var newFaces = []
    var oldFaceNum = 0
    for (oldFace in inputFaces) {
        if (oldFace.count == 4) {
            var a = oldFace[0]
            var b = oldFace[1]
            var c = oldFace[2]
            var d = oldFace[3]
            var facePointAbcd = facePointNums[oldFaceNum]
            var p = switchNums.call([a, b])
            var edgePointAb = edgePointNums[Int.cantorPair(p[0], p[1])]
            p = switchNums.call([d, a])
            var edgePointDa = edgePointNums[Int.cantorPair(p[0], p[1])]
            p = switchNums.call([b, c])
            var edgePointBc = edgePointNums[Int.cantorPair(p[0], p[1])]
            p = switchNums.call([c, d])
            var edgePointCd = edgePointNums[Int.cantorPair(p[0], p[1])]
            newFaces.add([a, edgePointAb, facePointAbcd, edgePointDa])
            newFaces.add([b, edgePointBc, facePointAbcd, edgePointAb])
            newFaces.add([c, edgePointCd, facePointAbcd, edgePointBc])
            newFaces.add([d, edgePointDa, facePointAbcd, edgePointCd])
        }
        oldFaceNum = oldFaceNum + 1
    }
    return [newPoints, newFaces]
}

var inputPoints = [
    Point.new(-1,  1,  1),
    Point.new(-1, -1,  1),
    Point.new( 1, -1,  1),
    Point.new( 1,  1,  1),
    Point.new( 1, -1, -1),
    Point.new( 1,  1, -1),
    Point.new(-1, -1, -1),
    Point.new(-1,  1, -1)
]

var inputFaces = [
    [0, 1, 2, 3],
    [3, 2, 4, 5],
    [5, 4, 6, 7],
    [7, 0, 3, 5],
    [7, 6, 1, 0],
    [6, 1, 2, 4]
]

var outputPoints = inputPoints.toList
var outputFaces  = inputFaces.toList
var iterations = 1
for (i in 0...iterations) {
    var res = cmcSubdiv.call(outputPoints, outputFaces)
    outputPoints = res[0]
    outputFaces  = res[1]
}
for (p in outputPoints) {
    Fmt.aprint([p.x, p.y, p.z], 7, 4, "[]")
}
System.print()
for (f in outputFaces) {
    Fmt.aprint(f, 2, 0, "[]")
}
