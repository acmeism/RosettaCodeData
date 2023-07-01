import "scheduler" for Scheduler
import "timer" for Timer
import "io" for Stdin

var start = System.clock
var stop = false

Scheduler.add {
    var n = 0
    while (true) {
        System.print(n)
        if (stop) {
            var elapsed = System.clock - start + n * 0.5
            System.print("Program has run for %(elapsed) seconds.")
            return
        }
        Timer.sleep(500)
        n = n + 1
    }
}

Stdin.isRaw = true  // enable control characters to go into stdin
while (true) {
    var b = Stdin.readByte()
    if (b == 3 || b == 28) break  // quits on pressing either Ctrl-C os Ctrl-\
}
Stdin.isRaw = false
stop = true
