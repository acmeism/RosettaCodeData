/* Audio_overlap_loop.wren */

class C {
    foreign static getInput(maxSize)

    foreign static play(args)
}

var fileName = "loop.wav"

var reps = 0
while (!reps || !reps.isInteger || reps < 1 || reps > 6) {
    System.write("Enter number of repetitions (1 to 6) : ")
    reps = Num.fromString(C.getInput(1))
}

var delay = 0
while (!delay || !delay.isInteger || delay < 50 || delay > 500) {
    System.write("Enter delay between repetitions in microseconds (50 to 500) : ")
    delay = Num.fromString(C.getInput(3))
}

var decay = 0
while (!decay || decay < 0.2 || decay > 0.9) {
    System.write("Enter decay between repetitions (0.2 to 0.9) : ")
    decay = Num.fromString(C.getInput(5))
}

var args = [fileName, "-V1", "echo", "0.8", "0.7"]
var decay2 = 1
for (i in 1..reps) {
    var delayS = (i * delay).toString
    decay2 = decay2 * decay
    var decayS = decay2.toString
    args.add(delayS)
    args.add(decayS)
}
C.play(args.join(" "))
