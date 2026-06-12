/* Using_a_speech_engine_to_highlight_words.wren */

import "./str" for Str

class C {
    foreign static usleep(usec)

    foreign static espeak(s)

    foreign static flushStdout()
}

var s = "Actions speak louder than words."
var prev = ""
var prevLen = 0
var bs = ""
for (word in s.split(" ")) {
    if (prevLen > 0) bs = "\b" * prevLen
    System.write("%(bs)%(prev)%(Str.upper(word)) ")
    C.flushStdout()
    C.espeak(word)
    prev= word + " "
    prevLen = word.count + 1
}
bs = "\b" * prevLen
C.usleep(1000)
System.print("%(bs)%(prev)")
