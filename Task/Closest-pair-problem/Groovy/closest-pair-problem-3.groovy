def elegantClosest(Collection pointCol) {
    assert pointCol
    List xList = (pointCol as List).sort { it.x }
    List yList = xList.clone().sort { it.y }
    reductionClosest(xList, xList)
}

def reductionClosest(List xPoints, List yPoints) {
//    assert xPoints && yPoints
//    assert (xPoints as Set) == (yPoints as Set)
    int n = xPoints.size()
    if (n < 10) return bruteClosest(xPoints)

    int nMid = Math.ceil(n/2)
    List xLeft = xPoints[0..<nMid]
    List xRight = xPoints[nMid..<n]
    Number xMid = xLeft[-1].x
    List yLeft = yPoints.findAll { it.x <= xMid }
    List yRight = yPoints.findAll { it.x > xMid }
    if (xRight[0].x == xMid) {
        yLeft = xLeft.collect{ it }.sort { it.y }
        yRight = xRight.collect{ it }.sort { it.y }
    }

    Map aLeft = reductionClosest(xLeft, yLeft)
    Map aRight = reductionClosest(xRight, yRight)
    Map aMin = aRight.distance < aLeft.distance ? aRight : aLeft
    List yMid = yPoints.findAll { (xMid - it.x).abs() < aMin.distance }
    int nyMid = yMid.size()
    if (nyMid < 2) return aMin

    Map answer = aMin
    (0..<(nyMid-1)).each { i ->
        ((i+1)..<nyMid).findAll { j ->
            (yMid[j].x - yMid[i].x).abs() < aMin.distance &&
            (yMid[j].y - yMid[i].y).abs() < aMin.distance &&
            yMid[j].distance(yMid[i]) < aMin.distance
        }.each { k ->
            if ((yMid[k].x - yMid[i].x).abs() < answer.distance && (yMid[k].y - yMid[i].y).abs() < answer.distance) {
                def ikDist = yMid[i].distance(yMid[k])
                if ( ikDist < answer.distance) {
                    answer = [distance:ikDist, points:[yMid[i],yMid[k]]]
                }
            }
        }
    }
    answer
}
