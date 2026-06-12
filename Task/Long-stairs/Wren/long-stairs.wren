import "random" for Random
import "./fmt" for Fmt

var totalSecs = 0
var totalSteps = 0
var rand = Random.new()
System.print("Seconds    steps behind    steps ahead")
System.print("-------    ------------    -----------")
for (trial in 1..10000) {
    var sbeh = 0
    var slen = 100
    var secs = 0
    while (sbeh < slen) {
        sbeh = sbeh + 1
        for (wiz in 1..5) {
            if (rand.int(slen) < sbeh) sbeh = sbeh + 1
            slen = slen + 1
        }
        secs = secs + 1
        if (trial == 1 && secs > 599 && secs < 610) {
            Fmt.print("$d        $d            $d", secs, sbeh, slen - sbeh)
        }
    }
    totalSecs  = totalSecs + secs
    totalSteps = totalSteps + slen
}
Fmt.print("\nAverage secs taken: $h", totalSecs/10000)
Fmt.print("Average final length of staircase: $h", totalSteps/10000)
