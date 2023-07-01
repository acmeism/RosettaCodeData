import "scheduler" for Scheduler
import "timer" for Timer
import "io" for Stdin, Stdout

Stdin.isRaw = true // no echoing or buffering

var b

Scheduler.add {
    b = Stdin.readByte()
}

System.print("Awaiting keypress..")
Timer.sleep(2000) // allow 2 seconds say
if (b) {
    System.write("The key with code %(b) was pressed")
    System.print((b > 31 && b < 127) ? " namely '%(String.fromByte(b))'." : ".")
} else {
    System.print("No key was pressed, carrying on...")
}

Stdin.isRaw = false
