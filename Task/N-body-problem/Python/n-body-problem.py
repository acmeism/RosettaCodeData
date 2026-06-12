import math

class Vector:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y, self.z + other.z)

    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y, self.z - other.z)

    def __mul__(self, other):
        return Vector(self.x * other, self.y * other, self.z * other)

    def __div__(self, other):
        return Vector(self.x / other, self.y / other, self.z / other)

    def __eq__(self, other):
        if isinstance(other, Vector):
            return self.x == other.x and self.y == other.y and self.z == other.z
        return False

    def __ne__(self, other):
        return not self.__eq__(other)

    def __str__(self):
        return '({x}, {y}, {z})'.format(x=self.x, y=self.y, z=self.z)

    def abs(self):
        return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)

origin = Vector(0, 0, 0)

class NBody:
    def __init__(self, fileName):
        with open(fileName, "r") as fh:
            lines = fh.readlines()
            gbt = lines[0].split()
            self.gc = float(gbt[0])
            self.bodies = int(gbt[1])
            self.timeSteps = int(gbt[2])
            self.masses = [0.0 for i in range(self.bodies)]
            self.positions = [origin for i in range(self.bodies)]
            self.velocities = [origin for i in range(self.bodies)]
            self.accelerations = [origin for i in range(self.bodies)]
            for i in range(self.bodies):
                self.masses[i] = float(lines[i*3 + 1])
                self.positions[i] = self.__decompose(lines[i*3 + 2])
                self.velocities[i] = self.__decompose(lines[i*3 + 3])

            print "Contents of", fileName
            for line in lines:
                print line.rstrip()
            print
            print "Body   :      x          y          z    |",
            print "     vx         vy         vz"

    def __decompose(self, line):
        xyz = line.split()
        x = float(xyz[0])
        y = float(xyz[1])
        z = float(xyz[2])
        return Vector(x, y, z)

    def __computeAccelerations(self):
        for i in xrange(self.bodies):
            self.accelerations[i] = origin
            for j in xrange(self.bodies):
                if i != j:
                    temp = self.gc * self.masses[j] / math.pow((self.positions[i] - self.positions[j]).abs(), 3)
                    self.accelerations[i] += (self.positions[j] - self.positions[i]) * temp
        return None

    def __computePositions(self):
        for i in xrange(self.bodies):
            self.positions[i] += self.velocities[i] + self.accelerations[i] * 0.5
        return None

    def __computeVelocities(self):
        for i in xrange(self.bodies):
            self.velocities[i] += self.accelerations[i]
        return None

    def __resolveCollisions(self):
        for i in xrange(self.bodies):
            for j in xrange(self.bodies):
                if self.positions[i] == self.positions[j]:
                    (self.velocities[i], self.velocities[j]) = (self.velocities[j], self.velocities[i])
        return None

    def simulate(self):
        self.__computeAccelerations()
        self.__computePositions()
        self.__computeVelocities()
        self.__resolveCollisions()
        return None

    def printResults(self):
        fmt = "Body %d : % 8.6f  % 8.6f  % 8.6f | % 8.6f  % 8.6f  % 8.6f"
        for i in xrange(self.bodies):
            print fmt % (i+1, self.positions[i].x, self.positions[i].y, self.positions[i].z, self.velocities[i].x, self.velocities[i].y, self.velocities[i].z)
        return None

nb = NBody("nbody.txt")
for i in xrange(nb.timeSteps):
    print "\nCycle %d" % (i + 1)
    nb.simulate()
    nb.printResults()
