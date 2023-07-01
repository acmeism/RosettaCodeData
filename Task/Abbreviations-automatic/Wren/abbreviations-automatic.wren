import "io" for File
import "/pattern" for Pattern
import "/seq" for Lst
import "/fmt" for Fmt

var p = Pattern.new("+1/s")
var lines = File.read("days_of_week.txt").split("\n").map { |l| l.trim() }
var i = 1
for (line in lines) {
    if (line == "") {
        if (i != lines.count) System.print()
    } else {
        var days = p.splitAll(line)
        if (days.count != 7) Fiber.abort("There aren't seven days in line %(i).")
        if (Lst.distinct(days).count < 7) { // implies some days have the same name
            System.print(" ∞  %(line)")
        } else {
            var len = 1
            while (true) {
                if (Lst.distinct(days.map { |d| d.take(len).join() }.toList).count == 7) {
                    Fmt.print("$2d $s", len, line)
                    break
                }
                len = len + 1
            }
        }
    }
    i = i + 1
}
