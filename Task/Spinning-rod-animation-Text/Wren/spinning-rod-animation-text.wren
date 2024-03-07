import "io" for Stdout
import "timer" for Timer

var a = "|/-\\"
System.write("\e[?25l")          // hide the cursor
var start = System.clock
var asleep = 0
while (true) {
    for (i in 0..3) {
        System.write("\e[2J")    // clear terminal
        System.write("\e[0;0H")  // place cursor at top left corner
        for (j in 0..79) {       // 80 character terminal width, say
            System.write(a[i])
        }
        Stdout.flush()
        Timer.sleep(250)         // suspends both current fiber & System.clock
        asleep = asleep + 250
    }
    var now = System.clock
    // stop after 20 seconds, say
    if (now * 1000 + asleep - start * 1000 >= 20000) break
}
System.print("\e[?25h")          // restore the cursor
