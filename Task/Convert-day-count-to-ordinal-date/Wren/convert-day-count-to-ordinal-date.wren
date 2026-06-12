import "./date" for Date

var dayCountToOrd = Fn.new { |dc| Date.zero.addYears(-1).addDays(dc) }

Date.default = Date.ukDate  // to print date in format DD/MM/YYYY

for (i in [0, 109573, 146096]) {
    System.print("Daycount: %(i)")
    for (j in 0..5) {
        System.print(dayCountToOrd.call(j * 146097 + i))
    }
    System.print()
}
