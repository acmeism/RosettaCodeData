/* speech_synthesis.wren */

class C {
    foreign static getInput(maxSize)

    foreign static espeak(s)
}

System.write("Enter something to say (up to 100 characters) : ")
var s = C.getInput(100)
C.espeak(s)
