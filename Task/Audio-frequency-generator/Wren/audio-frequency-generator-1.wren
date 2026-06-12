/* Audio_frequency_generator.wren */

class C {
    foreign static getInput(maxSize)

    foreign static play(args)
}

var freq = 0
while (!freq || !freq.isInteger || freq < 40 || freq > 10000) {
    System.write("Enter frequency in HZ (40 to 10000) : ")
    freq = Num.fromString(C.getInput(5))
}
var freqS = freq.toString

var vol = 0
while (!vol || vol < 1 || vol > 50) {
    System.write("Enter volume in dB (1 to 50)        : ")
    vol = Num.fromString(C.getInput(2))
}
var volS = vol.toString

var dur = 0
while (!dur || dur < 2 || dur > 10) {
    System.write("Enter duration in seconds (2 to 10) : ")
    dur = Num.fromString(C.getInput(2))
}
var durS = dur.toString

var kind = 0
while (!kind || !kind.isInteger || kind < 1 || kind > 3) {
    System.write("Enter kind (1 = Sine, 2 = Square, 3 = Sawtooth) : ")
    kind = Num.fromString(C.getInput(1))
}
var kindS = "sine"
if (kind == 2) {
    kindS = "square"
} else if (kind == 3) {
    kindS = "sawtooth"
}

var args = ["-n", "-V1", "synth", durS, kindS, freqS, "vol", volS, "dB"].join(" ")
C.play(args)
