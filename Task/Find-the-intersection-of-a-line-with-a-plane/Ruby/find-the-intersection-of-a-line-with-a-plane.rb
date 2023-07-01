require "matrix"

def intersectPoint(rayVector, rayPoint, planeNormal, planePoint)
    diff = rayPoint - planePoint
    prod1 = diff.dot planeNormal
    prod2 = rayVector.dot planeNormal
    prod3 = prod1 / prod2
    return rayPoint - rayVector * prod3
end

def main
    rv = Vector[0.0, -1.0, -1.0]
    rp = Vector[0.0, 0.0, 10.0]
    pn = Vector[0.0, 0.0, 1.0]
    pp = Vector[0.0, 0.0, 5.0]
    ip = intersectPoint(rv, rp, pn, pp)
    puts "The ray intersects the plane at %s" % [ip]
end

main()
