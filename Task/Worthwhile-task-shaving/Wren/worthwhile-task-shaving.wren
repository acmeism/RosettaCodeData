import "./fmt" for Fmt

var shaved = [1, 5, 30, 60, 300, 1800, 3600, 21600, 86400] // time shaved off in seconds
var columns = ["1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE", "5 MINUTES",
               "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY"]
var diy = 365.25
var minute = 60
var hour = minute * 60
var day = hour * 24
var week = day * 7
var month = day * diy / 12
var year = day * diy

var freq = [50 * diy, 5 * diy, diy, diy/7, 12, 1] // frequency per year
var mult = 5 // multiplier for table

var fmtTime = Fn.new { |t, interval|
   t = t.floor
   var pl = (t == 1) ? "" : "S"
   Fmt.write("$-12s ", t.toString + " " + interval + pl)
}

Fmt.print("$93m", "HOW OFTEN YOU DO THE TASK")
Fmt.lprint("$-12s | $-12s $-12s $-12s $-12s $-12s $-12s", ["SHAVED OFF", "50/DAY", "5/DAY", "DAILY", "WEEKLY", "MONTHLY", "YEARLY"])
System.print("-" * 93)
for (y in 0..8) {
    Fmt.write("$-12s | ", columns[y])
    for (x in 0..5) {
        var t = freq[x] * shaved[y] * mult
        if (t < minute) {
             fmtTime.call(t, "SECOND")
        } else if (t < hour) {
             fmtTime.call(t/minute, "MINUTE")
        } else if (t < day) {
             fmtTime.call(t/hour, "HOUR")
        } else if (t < 14 * day) {
             fmtTime.call(t/day, "DAY")
        } else if (t < 9 * week) {
             fmtTime.call(t/week, "WEEK")
        } else if (t < year) {
             fmtTime.call(t/month, "MONTH")
        } else {
             System.write(" " * 13)
        }
    }
    System.print()
}
