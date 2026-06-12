import "./ioutil" for FileUtil
import "./fmt" for Fmt

class Vector3D {
    construct new(x, y, z) {
        _x = x
        _y = y
        _z = z
    }

    x { _x }
    y { _y }
    z { _z }

    +(v) { Vector3D.new(_x + v.x, _y + v.y, _z + v.z) }
    -(v) { Vector3D.new(_x - v.x, _y - v.y, _z - v.z) }
    *(s) { Vector3D.new(s * _x, s * _y, s * _z) }

    mod  { (_x * _x + _y * _y + _z * _z).sqrt }
}

var Origin = Vector3D.new(0, 0, 0)

class NBody {
    construct new(fileName) {
        var lines = FileUtil.readLines(fileName)
        var gbt = lines[0].split(" ")
        _gc = Num.fromString(gbt[0])
        _bodies = Num.fromString(gbt[1])
        _timeSteps = Num.fromString(gbt[2])
        _masses = List.filled(_bodies, 0)
        _positions = List.filled(_bodies, null)
        _velocities = List.filled(_bodies, null)
        _accelerations = List.filled(_bodies, null)
        for (i in 0..._bodies) {
            _masses[i] = Num.fromString(lines[i * 3 + 1])
            _positions[i] = decompose_(lines[i * 3 + 2])
            _velocities[i] = decompose_(lines[i * 3 + 3])
        }
        System.print("Contents of %(fileName)")
        System.print(lines.join("\n"))
        System.write("Body   :      x          y          z    |")
        System.print("     vx         vy         vz")
    }

    timeSteps { _timeSteps }

    decompose_(line) {
        var xyz = line.split(" ").map { |e| Num.fromString(e) }.toList
        return Vector3D.new(xyz[0], xyz[1], xyz[2])
    }

    resolveCollisions_() {
        for (i in 0..._bodies) {
            for (j in i + 1..._bodies) {
                if (_positions[i].x == _positions[j].x &&
                    _positions[i].y == _positions[j].y &&
                    _positions[i].z == _positions[j].z) {
                    var temp = _velocities[i]
                    _velocities[i] = _velocities[j]
                    _velocities[j] = temp
                }
            }
        }
    }

    computeAccelerations_() {
        for (i in 0..._bodies) {
            _accelerations[i] = Origin
            for (j in 0..._bodies) {
                if (i != j) {
                    var temp = _gc * _masses[j] / (_positions[i] - _positions[j]).mod.pow(3)
                    _accelerations[i] = _accelerations[i] + (_positions[j] - _positions[i]) * temp
                }
            }
        }
    }

    computeVelocities_() {
        for (i in 0..._bodies) _velocities[i] = _velocities[i] + _accelerations[i]
    }

    computePositions_() {
        for (i in 0..._bodies) {
            _positions[i] = _positions[i] + _velocities[i] + _accelerations[i] * 0.5
        }
    }

    simulate() {
        computeAccelerations_()
        computePositions_()
        computeVelocities_()
        resolveCollisions_()
    }

    printResults() {
        var fmt = "Body $d : $9.6f  $9.6f  $9.6f | $9.6f  $9.6f  $9.6f"
        for (i in 0..._bodies) {
            Fmt.lprint(fmt,
                [
                    i + 1,
                    _positions[i].x,
                    _positions[i].y,
                    _positions[i].z,
                    _velocities[i].x,
                    _velocities[i].y,
                    _velocities[i].z
                ]
            )
        }
    }
}

var fileName = "nbody.txt"
var nb = NBody.new(fileName)
for (i in 1..nb.timeSteps) {
    System.print("\nCycle %(i)")
    nb.simulate()
    nb.printResults()
}
