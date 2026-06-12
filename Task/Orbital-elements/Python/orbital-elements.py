import math

class Vector:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y, self.z + other.z)

    def __mul__(self, other):
        return Vector(self.x * other, self.y * other, self.z * other)

    def __div__(self, other):
        return Vector(self.x / other, self.y / other, self.z / other)

    def __str__(self):
        return '({x}, {y}, {z})'.format(x=self.x, y=self.y, z=self.z)

    def abs(self):
        return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)

def mulAdd(v1, x1, v2, x2):
    return v1 * x1 + v2 * x2

def rotate(i, j, alpha):
    return [mulAdd(i,math.cos(alpha),j,math.sin(alpha)), mulAdd(i,-math.sin(alpha),j,math.cos(alpha))]

def orbitalStateVectors(semimajorAxis, eccentricity, inclination, longitudeOfAscendingNode, argumentOfPeriapsis, trueAnomaly):
    i = Vector(1, 0, 0)
    j = Vector(0, 1, 0)
    k = Vector(0, 0, 1)

    p = rotate(i, j, longitudeOfAscendingNode)
    i = p[0]
    j = p[1]
    p = rotate(j, k, inclination)
    j = p[0]
    p  =rotate(i, j, argumentOfPeriapsis)
    i = p[0]
    j = p[1]

    l = 2.0 if (eccentricity == 1.0) else 1.0 - eccentricity * eccentricity
    l *= semimajorAxis
    c = math.cos(trueAnomaly)
    s = math.sin(trueAnomaly)
    r = 1 / (1.0 + eccentricity * c)
    rprime = s * r * r / l
    position = mulAdd(i, c, j, s) * r
    speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c)
    speed = speed / speed.abs()
    speed = speed * math.sqrt(2.0 / r - 1.0 / semimajorAxis)

    return [position, speed]

ps = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0)
print "Position :", ps[0]
print "Speed    :", ps[1]
