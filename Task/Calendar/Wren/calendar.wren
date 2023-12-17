import "./date" for Date
import "./fmt" for Fmt
import "./seq" for Lst

var calendar = Fn.new { |year|
    var snoopy = "🐶"
    var days = "Su Mo Tu We Th Fr Sa"
    var months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    Fmt.print("$70m", snoopy)
    var yearStr = "--- %(year) ---"
    Fmt.print("$70m\n", yearStr)
    var first = List.filled(3, 0)
    var mlen = List.filled(3, 0)
    var c = 0
    for (chunk in Lst.chunks(months, 3)) {
        for (i in 0..2) Fmt.write("$20m     ", chunk[i])
        System.print()
        for (i in 0..2) System.write("%(days)     ")
        System.print()
        first[0] = Date.new(year, c*3 + 1, 1).dayOfWeek % 7
        first[1] = Date.new(year, c*3 + 2, 1).dayOfWeek % 7
        first[2] = Date.new(year, c*3 + 3, 1).dayOfWeek % 7
        mlen[0]  = Date.monthLength(year, c*3 + 1)
        mlen[1]  = Date.monthLength(year, c*3 + 2)
        mlen[2]  = Date.monthLength(year, c*3 + 3)
        for (i in 0..5) {
            for (j in 0..2) {
                var start = 1 + 7 * i - first[j]
                for (k in start..start+6) {
                    if (k >= 1 && k <= mlen[j]) {
                        Fmt.write("$2d ", k)
                    } else {
                        System.write("   ")
                    }
                }
                System.write("    ")
            }
            System.print()
        }
        System.print()
        c = c + 1
    }
}

calendar.call(1969)
