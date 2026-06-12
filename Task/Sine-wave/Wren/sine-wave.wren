import "./sound" for Wav

var sineWave = Fn.new { |frequency, seconds, sampleRate|
    var samples = seconds * sampleRate
    var result = List.filled(samples, 0)
    var interval = sampleRate / frequency
    for (i in 0...samples) {
        var angle = 2 * Num.pi * i / interval
        var b = (angle.sin * 127).truncate
        result[i] = (b >= 0) ? b : 256 + b
    }
    return result
}

var sampleRate = 44000
var buffer = sineWave.call(440, 5, sampleRate)
Wav.create("sinewave.wav", buffer, sampleRate)
