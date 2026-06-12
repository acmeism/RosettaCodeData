using GeometryTypes
import Base.abs, Base.print

Vect = Point3
Base.abs(p::Vect) = sqrt(sum(x -> x*x, p))
Base.print(io::IO, p::Vect) = print(io, "(", p[1], ", ", p[2], ", ", p[3], ")")
muladd(v1, x1, v2, x2) = v1 * x1 + v2 * x2
rotate(i, j, a) = Pair(muladd(i, cos(a), j, sin(a)), muladd(i, -sin(a), j, cos(a)))

function orbitalStateVectors(semimajorAxis, eccentricity, inclination,
    longitudeOfAscendingNode, argumentOfPeriapsis, trueAnomaly)

    i, j, k = Vect(1.0, 0.0, 0.0), Vect(0.0, 1.0, 0.0), Vect(0.0, 0.0, 1.0)
    p = rotate(i, j, longitudeOfAscendingNode)
    i, j = p
    p = rotate(j, k, inclination)
    p = rotate(i, p[1], argumentOfPeriapsis)
    i, j = p

    l = semimajorAxis * (eccentricity == 1.0 ? 2.0 : (1.0 - eccentricity * eccentricity))
    c, s = cos(trueAnomaly), sin(trueAnomaly)
    r = l / (1.0 + eccentricity * c)
    rprime, position = s * r * r / l, muladd(i, c, j, s) * r
    speed = muladd(i, rprime * c - r * s, j, rprime * s + r * c)
    speed /= abs(speed)
    speed *= sqrt(2.0 / r - 1.0 / semimajorAxis)
    return Pair(position, speed)
end

function testorbitalmath()
    (position, speed) = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0)
    println("Position : $position\nSpeed    : $speed")
end

testorbitalmath()
