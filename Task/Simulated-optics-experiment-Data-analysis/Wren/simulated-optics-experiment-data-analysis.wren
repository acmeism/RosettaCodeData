import "io" for File
import "os" for Process
import "./seq" for Lst
import "./assert" for Assert
import "./fmt" for Fmt

/* The data for one light pulse. */
class PulseData {
    construct new( logS, logL, logR, detectedL1, detectedL2, detectedR1, detectedR2) {
        _logS = logS
        _logL = logL
        _logR = logR
        _detectedL1 = detectedL1
        _detectedL2 = detectedL2
        _detectedR1 = detectedR1
        _detectedR2 = detectedR2
    }

    logS { _logS }
    logL { _logL }
    logR { _logR }

    detectedL1 { _detectedL1 }
    detectedL2 { _detectedL2 }
    detectedR1 { _detectedR1 }
    detectedR2 { _detectedR2 }

    toString {
        return "PulseData(" + "%(_logS), %(_logL), %(_logR)" +
               "%(_detectedL1), %(_detectedL2), %(_detectedR1), %(_detectedR2))"
    }

    // Swap detectedL1 and detectedL2.
    swapLchannels() {
        var t = _detectedL1
        _detectedL1 = _detectedL2
        _detectedL2 = t
    }

    // Swap detectedR1 and detectedR2.
    swapRchannels() {
        var t = _detectedR1
        _detectedR1 = _detectedR2
        _detectedR2 = t
    }

    // Swap channels on both right and left. This is done if the
    // light source was (1,90°) instead of (1,0°). For in that case
    // the orientations of the polarizing beam splitters, relative to
    // the light source, is different by 90°.
    swapLRchannels() {
        swapLchannels()
        swapRchannels()
    }
}

// Split the data into two subsets, according to whether a set
// item satisfies a predicate. The return value is a tuple, with
// those items satisfying the predicate in the first tuple entry, the
// other items in the second entry.
var splitData = Fn.new { |predicate, data| Lst.partitions(data, predicate) }

// Some data items are for a (1,0°) light pulse. The others are
// for a (1,90°) light pulse. Thus the light pulses are oriented
// differently with respect to the polarizing beam splitters. We
// adjust for that distinction here.
var adjustDataForLightPulseOrientation = Fn.new { |data|
    var pf = Fn.new { |item| item.logS == 0 }
    var split = splitData.call(pf, data)
    var data0  = split[0]
    var data90 = split[1]
    for (item in data90) item.swapLRchannels()
    return data0 + data90
}

// Split the data into four subsets: one subset for each
// arrangement of the two polarizing beam splitters.
var splitDataAccordingToPBSSetting = Fn.new { |data|
    var pfL = Fn.new { |item| item.logL == 0 }
    var split = splitData.call(pfL, data)
    var dataL1 = split[0]
    var dataL2 = split[1]
    var pfR = Fn.new { |item| item.logR == 0 }
    var splitL1 = splitData.call(pfR, dataL1)
    var dataL1R1 = splitL1[0]
    var dataL1R2 = splitL1[1]
    var splitL2 = splitData.call(pfR, dataL2)
    var dataL2R1 = splitL2[0]
    var dataL2R2 = splitL2[1]
    return [dataL1R1, dataL1R2, dataL2R1, dataL2R2]
}

// Compute the correlation coefficient for the subset of the data
// that corresponding to a particular setting of the polarizing beam splitters.
var computeCorrelationCoefficient = Fn.new { |angleL, angleR, data|
    // We make certain the orientations of beam splitters are
    // represented by perpendicular angles in the first and fourth
    // quadrant. This restriction causes no loss of generality, because
    // the orientation of the beam splitter is actually a rotated "X".
    Assert.ok([angleL, angleR].all { |x| 0 <= x && x < 90 })
    var perpendicularL = angleL - 90 // In Quadrant 4.
    var perpendicularR = angleR - 90 // In Quadrant 4.

    // Note that the sine is non-negative in Quadrant 1, and the cosine
    // is non-negative in Quadrant 4. Thus we can use the following
    // estimates for cosine and sine. This is Equation (2.4) in the
    // reference. (Note, one can also use Quadrants 1 and 2 and reverse
    // the roles of cosine and sine. And so on like that.)
    var N = data.count
    var NL1 = 0
    var NL2 = 0
    var NR1 = 0
    var NR2 = 0
    for (item in data) {
        NL1 = NL1 + item.detectedL1
        NL2 = NL2 + item.detectedL2
        NR1 = NR1 + item.detectedR1
        NR2 = NR2 + item.detectedR2
    }
    var sinL = (NL1 / N).sqrt
    var cosL = (NL2 / N).sqrt
    var sinR = (NR1 / N).sqrt
    var cosR = (NR2 / N).sqrt

    // Now we can apply the reference's Equation (2.3).
    var cosLR = (cosR * cosL) + (sinR * sinL)
    var sinLR = (sinR * cosL) - (cosR * sinL)

    // And then Equation (2.5).
    return (cosLR * cosLR) - (sinLR * sinLR)
}

// Read the raw data into a list.
var readRawData = Fn.new { |filename|
    var makeRecord = Fn.new { |line|
        var x = line.split(" ")
        x = x.map { |s| Num.fromString(s).truncate }.toList
        return PulseData.new(x[0], x[1], x[2], x[3], x[4], x[5], x[6])
    }

    var data = []
    var lines = File.read(filename).split("\n")
    var numPulses = Num.fromString(lines[0])
    for (i in 1..numPulses) {
        data.add(makeRecord.call(lines[i]))
    }
    return data
}

var args = Process.arguments
if (args.count != 1) {
    System.print("Please provide 1 command line argument: RAW_DATA_FILENAME")
    return
}
var filename = args[0]

// Polarizing beam splitter orientations commonly used in actual
// experiments. These must match the values used in the simulation
// itself. They are by design all either zero degrees or in the
// first quadrant.
var anglesL = [0, 45]
var anglesR = [22.5, 67.5]
Assert.ok((anglesL + anglesR).all { |x| 0 <= x && x < 90 })

var data = readRawData.call(filename)
data = adjustDataForLightPulseOrientation.call(data)
var split = splitDataAccordingToPBSSetting.call(data)
var dataL1R1 = split[0]
var dataL1R2 = split[1]
var dataL2R1 = split[2]
var dataL2R2 = split[3]

var kappaL1R1 = computeCorrelationCoefficient.call(anglesL[0], anglesR[0], dataL1R1)
var kappaL1R2 = computeCorrelationCoefficient.call(anglesL[0], anglesR[1], dataL1R2)
var kappaL2R1 = computeCorrelationCoefficient.call(anglesL[1], anglesR[0], dataL2R1)
var kappaL2R2 = computeCorrelationCoefficient.call(anglesL[1], anglesR[1], dataL2R2)

var chshContrast = -kappaL1R1 + kappaL1R2 + kappaL2R1 + kappaL2R2

// The nominal value of the CHSH contrast for the chosen polarizer
// orientations is 2*sqrt(2).
var chshContrastNominal = 2.sqrt * 2

Fmt.print()
Fmt.print("   light pulse events      $,10d", data.count)
Fmt.print()
Fmt.print("    correlation coefs")
Fmt.print("              $4.1f° $4.1f°   $+9.6f", anglesL[0], anglesR[0], kappaL1R1)
Fmt.print("              $4.1f° $4.1f°   $+9.6f", anglesL[0], anglesR[1], kappaL1R2)
Fmt.print("              $4.1f° $4.1f°   $+9.6f", anglesL[1], anglesR[0], kappaL2R1)
Fmt.print("              $4.1f° $4.1f°   $+9.6f", anglesL[1], anglesR[1], kappaL2R2)
Fmt.print()
Fmt.print("            CHSH contrast   $+9.6f", chshContrast)
Fmt.print("      2*sqrt(2) = nominal   $+9.6f", chshContrastNominal)
Fmt.print("               difference   $+9.6f", chshContrast - chshContrastNominal)

// A "CHSH violation" occurs if the CHSH contrast is > 2.
// https://en.wikipedia.org/w/index.php?title=CHSH_inequality&oldid=1142431418
Fmt.print()
Fmt.print("           CHSH violation   $+9.6f", chshContrast - 2)
Fmt.print()
