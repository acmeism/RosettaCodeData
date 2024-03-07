/* Record_sound.wren */

class C {
    foreign static getInput(maxSize)

    foreign static arecord(args)

    foreign static aplay(name)
}

var name = ""
while (name == "") {
    System.write("Enter output file name (without extension) : ")
    name = C.getInput(80)
}
name = name + ".wav"

var rate = 0
while (!rate || !rate.isInteger || rate < 2000 || rate > 192000) {
    System.write("Enter sampling rate in Hz (2000 to 192000) : ")
    rate = Num.fromString(C.getInput(6))
}
var rateS = rate.toString

var dur = 0
while (!dur || dur < 5 || dur > 30) {
    System.write("Enter duration in seconds (5 to 30)        : ")
    dur = Num.fromString(C.getInput(5))
}
var durS = dur.toString

System.print("\nOK, start speaking now...")
// Default arguments: -c 1, -t wav. Note only signed 16 bit format supported.
var args = ["-r", rateS, "-f", "S16_LE", "-d", durS, name]
C.arecord(args.join(" "))

System.print("\n'%(name)' created on disk and will now be played back...")
C.aplay(name)
System.print("\nPlay-back completed.")
