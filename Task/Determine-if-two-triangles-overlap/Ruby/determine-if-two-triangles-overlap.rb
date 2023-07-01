require "matrix"

def det2D(p1, p2, p3)
    return p1[0] * (p2[1] - p3[1]) + p2[0] * (p3[1] - p1[1]) + p3[0] * (p1[1] - p2[1])
end

def checkTriWinding(p1, p2, p3, allowReversed)
    detTri = det2D(p1, p2, p3)
    if detTri < 0.0 then
        if allowReversed then
            p2[0], p3[0] = p3[0], p2[0]
            p2[1], p3[1] = p3[1], p2[1]
        else
            raise "Triangle has incorrect winding"
        end
    end
end

def boundaryCollideChk(p1, p2, p3, eps)
    return det2D(p1, p2, p3) < eps
end

def boundaryDoesntCollideChk(p1, p2, p3, eps)
    return det2D(p1, p2, p3) <= eps
end

def triTri2D(t1, t2, eps, allowReversed, onBoundary)
    # Triangles must be expressed anti-clockwise
    checkTriWinding(t1[0], t1[1], t1[2], allowReversed)
    checkTriWinding(t2[0], t2[1], t2[2], allowReversed)

    if onBoundary then
        # Points on the boundary are considered as colliding
        chkEdge = -> (p1, p2, p3, eps) { boundaryCollideChk(p1, p2, p3, eps) }
    else
        # Points on the boundary are not considered as colliding
        chkEdge = -> (p1, p2, p3, eps) { boundaryDoesntCollideChk(p1, p2, p3, eps) }
    end

    # For edge E of triangle 1
    for i in 0..2 do
        j = (i + 1) % 3

        # Check all points of trangle 2 lay on the external side of the edge E. If
        # they do, the triangles do not collide.
        if chkEdge.(t1[i], t1[j], t2[0], eps) and chkEdge.(t1[i], t1[j], t2[1], eps) and chkEdge.(t1[i], t1[j], t2[2], eps) then
            return false
        end
    end

    # For edge E of triangle 2
    for i in 0..2 do
        j = (i + 1) % 3

        # Check all points of trangle 1 lay on the external side of the edge E. If
        # they do, the triangles do not collide.
        if chkEdge.(t2[i], t2[j], t1[0], eps) and chkEdge.(t2[i], t2[j], t1[1], eps) and chkEdge.(t2[i], t2[j], t1[2], eps) then
            return false
        end
    end

    # The triangles collide
    return true
end

def main
    t1 = [Vector[0,0], Vector[5,0], Vector[0,5]]
    t2 = [Vector[0,0], Vector[5,0], Vector[0,6]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, true)]

    t1 = [Vector[0,0], Vector[0,5], Vector[5,0]]
    t2 = [Vector[0,0], Vector[0,5], Vector[5,0]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, true, true)]

    t1 = [Vector[  0,0], Vector[ 5,0], Vector[ 0,5]]
    t2 = [Vector[-10,0], Vector[-5,0], Vector[-1,6]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, true)]

    t1 = [Vector[0,0], Vector[  5, 0], Vector[2.5,5]]
    t2 = [Vector[0,4], Vector[2.5,-1], Vector[  5,4]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, true)]

    t1 = [Vector[0,0], Vector[1,1], Vector[0,2]]
    t2 = [Vector[2,1], Vector[3,0], Vector[3,2]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, true)]

    t1 = [Vector[0,0], Vector[1, 1], Vector[0,2]]
    t2 = [Vector[2,1], Vector[3,-2], Vector[3,4]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, true)]

    # Barely touching
    t1 = [Vector[0,0], Vector[1,0], Vector[0,1]]
    t2 = [Vector[1,0], Vector[2,0], Vector[1,1]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, true)]

    # Barely touching
    t1 = [Vector[0,0], Vector[1,0], Vector[0,1]]
    t2 = [Vector[1,0], Vector[2,0], Vector[1,1]]
    print "Triangle: ", t1, "\n"
    print "Triangle: ", t2, "\n"
    print "overlap: %s\n\n" % [triTri2D(t1, t2, 0.0, false, false)]
end

main()
