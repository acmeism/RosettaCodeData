import "./sound" for Wav

var sampleRate = 44100
var duration = 8
var data = List.filled(sampleRate * duration, 0)
var freqs = [261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3]
for (j in 0...duration) {
    var freq = freqs[j]
    var omega = 2 * Num.pi * freq
    for (i in 0...sampleRate) {
        var y = (32 * (omega * i / sampleRate).sin).round & 255
        data[i + j * sampleRate] = y
    }
}
Wav.create("musical_scale.wav", data, sampleRate)
