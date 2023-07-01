import "os" for Process
import "timer" for Timer
import "/date" for Date
import "/fmt" for Fmt

var watches = ["First", "Middle", "Morning", "Forenoon", "Afternoon", "Dog", "First"]

var args = Process.arguments
if (args.count == 0) {
    System.print("Please enter current time in the format (24 hour clock): hh:mm:ss.")
    return
}

var now = Date.parse(args[0], Date.isoTime)

while (true) {
    var h = now.hour
    var m = now.minute
    var s = now.second
    if ((m == 0 || m == 30) && s == 0) {
        var bell = (m == 30) ? 1 : 0
        var bells = (h*2 + bell) % 8
        var watch = (h/4).floor + 1
        if (bells == 0) {
            bells = 8
            watch = watch - 1
        }
        var sound = "\a" * bells
        var pl = (bells != 1) ? "s" : ""
        var w = watches[watch] + " watch"
        if (watch == 5) {
            if (bells < 5) {
                w = "First " + w
            } else {
                w = "Last " + w
            }
        }
        Fmt.lprint("$s$02d:$02d = $d bell$s : $s", [sound, h, m, bells, pl, w])
    }
    Timer.sleep(1000)
    now = now.addSeconds(1)
}
