import "io" for File
import "./crypto" for Bytes
import "./fmt" for Fmt
import "./math" for Nums
import "./seq" for Lst

var freqs = [261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3]
var notes = ["Doh", "Ray", "Mee", "Fah", "Soh", "Lah", "Tee", "doh"]

var getNote = Fn.new { |freq|
    var n = freqs.count
    var index = n
    for (i in 0...n) {
        if (freq <= freqs[i]) {
            index = i
            break
        }
    }
    if (index == 0) {
        return "Doh-"
    } else if (index == n) {
        return "doh+"
    } else {
        if (freqs[index] - freq <= freq - freqs[index-1]) {
            return notes[index] + "-"
        }
        return notes[index-1] + "+"
    }
}

var bytes = File.read("musical_scale.wav").bytes.toList
var hdr = bytes[0..43]

// check header parameters
var sampleRate = Bytes.toIntLE(hdr[24..27])
System.print("Sample Rate    : %(sampleRate)")
var dataLength = Bytes.toIntLE(hdr[40..-1])
var duration = dataLength / sampleRate
System.print("Duration       : %(duration)")

var sum = 0
var nbytes = 20
System.print("Bytes examined : %(nbytes) per sample")
for (data in Lst.chunks(bytes[44..-1], sampleRate)) {
    for (i in 1..nbytes) {
        var bf = data[i] / 32
        var freq = bf.asin * sampleRate / (i * Num.pi * 2)
        sum = sum + freq
    }
}
var cav = sum / (duration * nbytes)
Fmt.print("\nComputed average frequency = $.1f Hz ($s)", cav, getNote.call(cav))
var aav = Nums.mean(freqs)
Fmt.print("Actual average frequency   = $.1f Hz ($s)", aav, getNote.call(aav))
