import "random" for Random
import "io" for File
import "os" for Process
import "./queue" for Queue
import "./vector" for Vector2
import "./assert" for Assert

var Rand = Random.new()
Vector2.useDegrees = true

/* Returns the projection of vector u onto vector v. */
var Projection = Fn.new { |u, v|
    var scalar = u.dot(v) / v.dot(v)
    return v * scalar
}

/* A mechanism represents a part of the experimental apparatus. */
class Mechanism {
    run() { Fiber.abort("Not implemented.") }
}

/*  A LightSource occasionally emits oppositely plane-polarized
    light pulses, of fixed amplitude, polarized 90° with respect to
    each other. The pulses are represented by the vectors (1,0°) and
    (1,90°), respectively. One is emitted to the left, the other to
    the right. The probability is 1/2 that the (1,0°) pulse is emitted
    to the left.

    The LightSource records which pulse it emitted in which direction.
*/
class LightSource is Mechanism {
    construct new(L, R, log) {
        _L = L      // Queue gets (1,0°) or (1,90°)
        _R = R      // Queue gets (1,90°) or (1,0°)
        _log = log  // Queue gets 0 if (1,0°) sent left, else 1.
    }

    // Emit a light pulse.
    run() {
        var n = Rand.int(2) // 0 or 1
        _L.push(Vector2.fromPolar(1, n * 90))
        _R.push(Vector2.fromPolar(1, 90 - (n * 90)))
        _log.push(n)
    }
}

/*  A polarizing beam splitter takes a plane-polarized light pulse
    and splits it into two plane-polarized pulses. The directions of
    polarization of the two output pulses are determined solely by the
    angular setting of the beam splitter—NOT by the angle of the
    original pulse. However, the amplitudes of the output pulses
    depend on the angular difference between the impinging light pulse
    and the beam splitter.

    Each beam splitter is designed to select randomly between one of
    two angle settings. It records which setting it selected (by
    putting that information into one of its output queues).
*/
class PolarizingBeamSplitter is Mechanism {
    construct new(S, S1, S2, log, angles) {
        _S = S              // Vector queue to read from.
        _S1 = S1            // One vector queue out.
        _S2 = S2            // The other vector queue out.
        _log = log          // The other vector queue out.
        _angles = angles
    }

    // Split a light pulse into two pulses. One of output pulses
    // may be visualized as the vector projection of the input pulse
    // onto the direction vector of the beam splitter. The other
    // output pulse is the difference between the input pulse and the
    // first output pulse: in other words, the orthogonal component.
    run() {
        var angleSetting = Rand.int(2) // 0 or 1
        _log.push(angleSetting)

        var angle = _angles[angleSetting]
        Assert.ok(0 <= angle && angle < 90)
        var v = _S.pop()
        var v1 = Projection.call(v, Vector2.fromPolar(1, angle))
        var v2 = v - v1

        _S1.push(v1)
        _S2.push(v2)
    }
}

/*  Our light detector is assumed to work as follows: if a
    uniformly distributed random number between 0 and 1 is less than
    or equal to the intensity (square of the amplitude) of an
    impinging light pulse, then the detector outputs a 1, meaning the
    pulse was detected. Otherwise it outputs a 0, representing the
    quiescent state of the detector.
*/
class LightDetector is Mechanism {
    construct new(In, Out) {
        _In = In
        _Out = Out
    }

    // When a light pulse comes in, either detect it or do not.
    run() {
        var pulse = _In.pop()
        var intensity = pulse.square
        _Out.push(Rand.float(1) <= intensity ? 1 : 0)
    }
}

/*  The data synchronizer combines the raw data from the logs and
    the detector outputs, putting them into dictionaries of
    corresponding data.
*/
class DataSynchronizer is Mechanism {
    construct new(logS, logL, logR,
                  detectedL1, detectedL2,
                  detectedR1, detectedR2,
                  dataout) {
        _logS = logS
        _logL = logL
        _logR = logR
        _detectedL1 = detectedL1
        _detectedL2 = detectedL2
        _detectedR1 = detectedR1
        _detectedR2 = detectedR2
        _dataout = dataout
    }

    // This method does the synchronizing.
    run() {
        _dataout.push(
            {
                "logS" : _logS.pop(),
                "logL" : _logL.pop(),
                "logR" : _logR.pop(),
                "detectedL1" : _detectedL1.pop(),
                "detectedL2" : _detectedL2.pop(),
                "detectedR1" : _detectedR1.pop(),
                "detectedR2" : _detectedR2.pop()
            }
        )
    }
}

var saveRawData = Fn.new { |filename, data|
    File.create(filename) { |f|
        f.writeBytes(data.count.toString)
        f.writeBytes("\n")
        for (entry in data) {
            f.writeBytes(entry["logS"].toString)
            f.writeBytes(" ")
            f.writeBytes(entry["logL"].toString)
            f.writeBytes(" ")
            f.writeBytes(entry["logR"].toString)
            f.writeBytes(" ")
            f.writeBytes(entry["detectedL1"].toString)
            f.writeBytes(" ")
            f.writeBytes(entry["detectedL2"].toString)
            f.writeBytes(" ")
            f.writeBytes(entry["detectedR1"].toString)
            f.writeBytes(" ")
            f.writeBytes(entry["detectedR2"].toString)
            f.writeBytes("\n")
        }
    }
}

var args = Process.arguments
if (args.count != 2) {
    System.print("Please provide 2 command line arguments: NUM_PULSES RAW_DATA_FILENAME]")
    return
}
var numPulses = Num.fromString(args[0])
var filename = args[1]

// Angles commonly used in actual experiments. Whatever angles you
// use have to be zero degrees or placed in Quadrant 1. This
// constraint comes with no loss of generality, because a
// polarizing beam splitter is actually a sort of rotated
// "X". Therefore its orientation can be specified by any one of
// the arms of the X. Using the Quadrant 1 arm simplifies data
// analysis.
var anglesL = [0, 45]
var anglesR = [22.5, 67.5]
Assert.ok((anglesL + anglesR).all { |x| 0 <= x && x < 90 })

// Queues used for communications between the mechanisms. (Note that
// the direction of communication is always forwards in time.)
var logS = Queue.new()
var logL = Queue.new()
var logR = Queue.new()
var L = Queue.new()
var R = Queue.new()
var L1 = Queue.new()
var L2 = Queue.new()
var R1 = Queue.new()
var R2 = Queue.new()
var detectedL1 = Queue.new()
var detectedL2 = Queue.new()
var detectedR1 = Queue.new()
var detectedR2 = Queue.new()
var dataout = Queue.new()

// Mechanisms to be run.
var mechanisms = [
    LightSource.new(L, R, logS),
    PolarizingBeamSplitter.new(L, L1, L2, logL, anglesL),
    PolarizingBeamSplitter.new(R, R1, R2, logR, anglesR),
    LightDetector.new(L1, detectedL1),
    LightDetector.new(L2, detectedL2),
    LightDetector.new(R1, detectedR1),
    LightDetector.new(R2, detectedR2),
    DataSynchronizer.new(logS, logL, logR, detectedL1, detectedL2, detectedR1, detectedR2, dataout)
]

var data = []
for (i in 0...numPulses) {
    for (m in mechanisms) m.run()
    data.add(dataout.pop())
}
saveRawData.call(filename, data)
