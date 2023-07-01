package main

import (
    "fmt"
    "sort"
)

type (
    Point [3]float64
    Face  []int

    Edge struct {
        pn1 int   // point number 1
        pn2 int   // point number 2
        fn1 int   // face number 1
        fn2 int   // face number 2
        cp  Point // center point
    }

    PointEx struct {
        p Point
        n int
    }
)

func sumPoint(p1, p2 Point) Point {
    sp := Point{}
    for i := 0; i < 3; i++ {
        sp[i] = p1[i] + p2[i]
    }
    return sp
}

func mulPoint(p Point, m float64) Point {
    mp := Point{}
    for i := 0; i < 3; i++ {
        mp[i] = p[i] * m
    }
    return mp
}

func divPoint(p Point, d float64) Point {
    return mulPoint(p, 1.0/d)
}

func centerPoint(p1, p2 Point) Point {
    return divPoint(sumPoint(p1, p2), 2)
}

func getFacePoints(inputPoints []Point, inputFaces []Face) []Point {
    facePoints := make([]Point, len(inputFaces))
    for i, currFace := range inputFaces {
        facePoint := Point{}
        for _, cpi := range currFace {
            currPoint := inputPoints[cpi]
            facePoint = sumPoint(facePoint, currPoint)
        }
        facePoint = divPoint(facePoint, float64(len(currFace)))
        facePoints[i] = facePoint
    }
    return facePoints
}

func getEdgesFaces(inputPoints []Point, inputFaces []Face) []Edge {
    var edges [][3]int
    for faceNum, face := range inputFaces {
        numPoints := len(face)
        for pointIndex := 0; pointIndex < numPoints; pointIndex++ {
            pointNum1 := face[pointIndex]
            var pointNum2 int
            if pointIndex < numPoints-1 {
                pointNum2 = face[pointIndex+1]
            } else {
                pointNum2 = face[0]
            }
            if pointNum1 > pointNum2 {
                pointNum1, pointNum2 = pointNum2, pointNum1
            }
            edges = append(edges, [3]int{pointNum1, pointNum2, faceNum})
        }
    }
    sort.Slice(edges, func(i, j int) bool {
        if edges[i][0] == edges[j][0] {
            if edges[i][1] == edges[j][1] {
                return edges[i][2] < edges[j][2]
            }
            return edges[i][1] < edges[j][1]
        }
        return edges[i][0] < edges[j][0]
    })
    numEdges := len(edges)
    eIndex := 0
    var mergedEdges [][4]int
    for eIndex < numEdges {
        e1 := edges[eIndex]
        if eIndex < numEdges-1 {
            e2 := edges[eIndex+1]
            if e1[0] == e2[0] && e1[1] == e2[1] {
                mergedEdges = append(mergedEdges, [4]int{e1[0], e1[1], e1[2], e2[2]})
                eIndex += 2
            } else {
                mergedEdges = append(mergedEdges, [4]int{e1[0], e1[1], e1[2], -1})
                eIndex++
            }
        } else {
            mergedEdges = append(mergedEdges, [4]int{e1[0], e1[1], e1[2], -1})
            eIndex++
        }
    }
    var edgesCenters []Edge
    for _, me := range mergedEdges {
        p1 := inputPoints[me[0]]
        p2 := inputPoints[me[1]]
        cp := centerPoint(p1, p2)
        edgesCenters = append(edgesCenters, Edge{me[0], me[1], me[2], me[3], cp})
    }
    return edgesCenters
}

func getEdgePoints(inputPoints []Point, edgesFaces []Edge, facePoints []Point) []Point {
    edgePoints := make([]Point, len(edgesFaces))
    for i, edge := range edgesFaces {
        cp := edge.cp
        fp1 := facePoints[edge.fn1]
        var fp2 Point
        if edge.fn2 == -1 {
            fp2 = fp1
        } else {
            fp2 = facePoints[edge.fn2]
        }
        cfp := centerPoint(fp1, fp2)
        edgePoints[i] = centerPoint(cp, cfp)
    }
    return edgePoints
}

func getAvgFacePoints(inputPoints []Point, inputFaces []Face, facePoints []Point) []Point {
    numPoints := len(inputPoints)
    tempPoints := make([]PointEx, numPoints)
    for faceNum := range inputFaces {
        fp := facePoints[faceNum]
        for _, pointNum := range inputFaces[faceNum] {
            tp := tempPoints[pointNum].p
            tempPoints[pointNum].p = sumPoint(tp, fp)
            tempPoints[pointNum].n++
        }
    }
    avgFacePoints := make([]Point, numPoints)
    for i, tp := range tempPoints {
        avgFacePoints[i] = divPoint(tp.p, float64(tp.n))
    }
    return avgFacePoints
}

func getAvgMidEdges(inputPoints []Point, edgesFaces []Edge) []Point {
    numPoints := len(inputPoints)
    tempPoints := make([]PointEx, numPoints)
    for _, edge := range edgesFaces {
        cp := edge.cp
        for _, pointNum := range []int{edge.pn1, edge.pn2} {
            tp := tempPoints[pointNum].p
            tempPoints[pointNum].p = sumPoint(tp, cp)
            tempPoints[pointNum].n++
        }
    }
    avgMidEdges := make([]Point, len(tempPoints))
    for i, tp := range tempPoints {
        avgMidEdges[i] = divPoint(tp.p, float64(tp.n))
    }
    return avgMidEdges
}

func getPointsFaces(inputPoints []Point, inputFaces []Face) []int {
    numPoints := len(inputPoints)
    pointsFaces := make([]int, numPoints)
    for faceNum := range inputFaces {
        for _, pointNum := range inputFaces[faceNum] {
            pointsFaces[pointNum]++
        }
    }
    return pointsFaces
}

func getNewPoints(inputPoints []Point, pointsFaces []int, avgFacePoints, avgMidEdges []Point) []Point {
    newPoints := make([]Point, len(inputPoints))
    for pointNum := range inputPoints {
        n := float64(pointsFaces[pointNum])
        m1, m2, m3 := (n-3)/n, 1.0/n, 2.0/n
        oldCoords := inputPoints[pointNum]
        p1 := mulPoint(oldCoords, m1)
        afp := avgFacePoints[pointNum]
        p2 := mulPoint(afp, m2)
        ame := avgMidEdges[pointNum]
        p3 := mulPoint(ame, m3)
        p4 := sumPoint(p1, p2)
        newPoints[pointNum] = sumPoint(p4, p3)
    }
    return newPoints
}

func switchNums(pointNums [2]int) [2]int {
    if pointNums[0] < pointNums[1] {
        return pointNums
    }
    return [2]int{pointNums[1], pointNums[0]}
}

func cmcSubdiv(inputPoints []Point, inputFaces []Face) ([]Point, []Face) {
    facePoints := getFacePoints(inputPoints, inputFaces)
    edgesFaces := getEdgesFaces(inputPoints, inputFaces)
    edgePoints := getEdgePoints(inputPoints, edgesFaces, facePoints)
    avgFacePoints := getAvgFacePoints(inputPoints, inputFaces, facePoints)
    avgMidEdges := getAvgMidEdges(inputPoints, edgesFaces)
    pointsFaces := getPointsFaces(inputPoints, inputFaces)
    newPoints := getNewPoints(inputPoints, pointsFaces, avgFacePoints, avgMidEdges)
    var facePointNums []int
    nextPointNum := len(newPoints)
    for _, facePoint := range facePoints {
        newPoints = append(newPoints, facePoint)
        facePointNums = append(facePointNums, nextPointNum)
        nextPointNum++
    }
    edgePointNums := make(map[[2]int]int)
    for edgeNum := range edgesFaces {
        pointNum1 := edgesFaces[edgeNum].pn1
        pointNum2 := edgesFaces[edgeNum].pn2
        edgePoint := edgePoints[edgeNum]
        newPoints = append(newPoints, edgePoint)
        edgePointNums[[2]int{pointNum1, pointNum2}] = nextPointNum
        nextPointNum++
    }
    var newFaces []Face
    for oldFaceNum, oldFace := range inputFaces {
        if len(oldFace) == 4 {
            a, b, c, d := oldFace[0], oldFace[1], oldFace[2], oldFace[3]
            facePointAbcd := facePointNums[oldFaceNum]
            edgePointAb := edgePointNums[switchNums([2]int{a, b})]
            edgePointDa := edgePointNums[switchNums([2]int{d, a})]
            edgePointBc := edgePointNums[switchNums([2]int{b, c})]
            edgePointCd := edgePointNums[switchNums([2]int{c, d})]
            newFaces = append(newFaces, Face{a, edgePointAb, facePointAbcd, edgePointDa})
            newFaces = append(newFaces, Face{b, edgePointBc, facePointAbcd, edgePointAb})
            newFaces = append(newFaces, Face{c, edgePointCd, facePointAbcd, edgePointBc})
            newFaces = append(newFaces, Face{d, edgePointDa, facePointAbcd, edgePointCd})
        }
    }
    return newPoints, newFaces
}

func main() {
    inputPoints := []Point{
        {-1.0, 1.0, 1.0},
        {-1.0, -1.0, 1.0},
        {1.0, -1.0, 1.0},
        {1.0, 1.0, 1.0},
        {1.0, -1.0, -1.0},
        {1.0, 1.0, -1.0},
        {-1.0, -1.0, -1.0},
        {-1.0, 1.0, -1.0},
    }

    inputFaces := []Face{
        {0, 1, 2, 3},
        {3, 2, 4, 5},
        {5, 4, 6, 7},
        {7, 0, 3, 5},
        {7, 6, 1, 0},
        {6, 1, 2, 4},
    }

    outputPoints := make([]Point, len(inputPoints))
    outputFaces := make([]Face, len(inputFaces))
    copy(outputPoints, inputPoints)
    copy(outputFaces, inputFaces)
    iterations := 1
    for i := 0; i < iterations; i++ {
        outputPoints, outputFaces = cmcSubdiv(outputPoints, outputFaces)
    }
    for _, p := range outputPoints {
        fmt.Printf("% .4f\n", p)
    }
    fmt.Println()
    for _, f := range outputFaces {
        fmt.Printf("%2d\n", f)
    }
}
