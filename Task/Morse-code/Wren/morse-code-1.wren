import "./str" for Str
import "./sound" for Wav

var charToMorse = {
    "!": "---.",   "\"": ".-..-.",  "$": "...-..-",  "'": ".----.",
    "(": "-.--.",  ")": "-.--.-",   "+": ".-.-.",    ",": "--..--",
    "-": "-....-", ".": ".-.-.-",   "/": "-..-.",
    "0": "-----",  "1": ".----",    "2": "..---",    "3": "...--",
    "4": "....-",  "5": ".....",    "6": "-....",    "7": "--...",
    "8": "---..",  "9": "----.",
    ":": "---...",  ";": "-.-.-.",  "=": "-...-",    "?": "..--..",
    "@": ".--.-.",
    "A": ".-",      "B": "-...",     "C": "-.-.",    "D": "-..",
    "E": ".",       "F": "..-.",     "G": "--.",     "H": "....",
    "I": "..",      "J": ".---",     "K": "-.-",     "L": ".-..",
    "M": "--",      "N": "-.",       "O": "---",     "P": ".--.",
    "Q": "--.-",    "R": ".-.",      "S": "...",     "T": "-",
    "U": "..-",     "V": "...-",     "W": ".--",     "X": "-..-",
    "Y": "-.--",    "Z": "--..",
    "[": "-.--.",   "]": "-.--.-",   "_": "..--.-"
}

var textToMorse = Fn.new { |text|
    text = Str.upper(text)
    var morse = ""
    for (c in text) {
        if (c == " ") {
            morse = morse + (" " * 7)
        } else {
            var m = charToMorse[c]
            if (m) morse = morse + m.join(" ") + "   "
        }
    }
    return morse.trimEnd()
}

var morse = textToMorse.call("Hello world!")
System.print(morse) // print to terminal

// now create a .wav file
morse = morse.replace("-", "...") // replace 'dash' with 3 'dot's
var data = []
var sampleRate = 44100
var samples = 0.2 * sampleRate // number of samples assuming 'dot' takes 200 ms.
var freq = 500 // say
var omega = 2 * Num.pi * freq
for (c in morse) {
    if (c == ".") {
        for (s in 0...samples) {
            var value = (32 * (omega * s / sampleRate).sin).round & 255
            data.add(value)
        }
    } else {
        for (s in 0...samples) data.add(0)
    }
}
Wav.create("morse_code.wav", data, sampleRate)
