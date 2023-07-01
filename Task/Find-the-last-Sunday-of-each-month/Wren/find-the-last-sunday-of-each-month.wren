import "os" for Process
import "/date" for Date

var args = Process.arguments
if (args.count != 1) {
    Fiber.abort("Please pass just the year to be processed.")
}

var year = Num.fromString(args[0])
System.print("The dates of the last Sundays in the month for %(year) are:")
Date.default = Date.isoDate
for (m in 1..12) {
    var d = Date.monthLength(year, m)
    var dt = Date.new(year, m, d)
    var wd = dt.dayOfWeek
    if (wd == 7) {
        System.print(dt)
    } else {
        System.print(dt.addDays(-wd))
    }
}
