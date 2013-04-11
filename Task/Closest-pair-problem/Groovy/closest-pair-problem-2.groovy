def bruteClosest(Collection pointCol) {
    assert pointCol
    List l = pointCol
    int n = l.size()
    assert n > 1
    if (n == 2) return [distance:l[0].distance(l[1]), points:[l[0],l[1]]]
    def answer = [distance: Double.POSITIVE_INFINITY]
    (0..<(n-1)).each { i ->
        ((i+1)..<n).findAll { j ->
            (l[i].x - l[j].x).abs() < answer.distance &&
            (l[i].y - l[j].y).abs() < answer.distance
        }.each { j ->
            if ((l[i].x - l[j].x).abs() < answer.distance &&
                (l[i].y - l[j].y).abs() < answer.distance) {
                def dist = l[i].distance(l[j])
                if (dist < answer.distance) {
                    answer = [distance:dist, points:[l[i],l[j]]]
                }
            }
        }
    }
    answer
}
