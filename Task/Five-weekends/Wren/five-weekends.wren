import "./date" for Date
import "./seq" for Lst

var dates = []
var years = []
for (y in 1900..2100) {
    var hasFive = false
    for (m in 1..12) {
        var fri = 0
        var sat = 0
        var sun = 0
        for (d in 1..Date.monthLength(y, m)) {
            var d = Date.new(y, m, d)
            var dow = d.dayOfWeek
            if (dow == 5) {
                fri = fri + 1
            } else if (dow == 6) {
                sat = sat + 1
            } else if (dow == 7) {
                sun = sun + 1
            }
        }
        var fd = Date.new(y, m, 1)
        if (fri == 5 && sat == 5 && sun == 5) {
            dates.add(fd)
            hasFive = true
        }
    }
    if (!hasFive) years.add(y)
}

Date.default = "mmm|-|yyyy"
System.print("Between 1900 and 2100:-")
System.print("  There are %(dates.count) months that have five full weekends.")
System.print("  The first 5 are:")
for (i in 0..4) System.print("    %(dates[i])")
System.print("  and the last 5 are:")
for (i in -5..-1) System.print("    %(dates[i])")
System.print("\n  There are %(years.count) years that do not have at least one five-weekend month, namely:")
var chunks = Lst.chunks(years, 10)
for (i in 0...chunks.count) System.print("    %(chunks[i])")
