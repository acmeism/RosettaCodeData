import "./date" for Date

var days = ["Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday"]

var anchorDay = Fn.new { |y| (2 + 5 * (y%4) + 4 *(y%100) + 6 * (y%400)) % 7 }

var isLeapYear = Fn.new { |y| y%4 == 0 && (y%100 != 0 || y%400 == 0) }

var firstDaysCommon = [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
var firstDaysLeap   = [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]

var dates = [
    "1800-01-06",
    "1875-03-29",
    "1915-12-07",
    "1970-12-23",
    "2043-05-14",
    "2077-02-12",
    "2101-04-02"
]

System.print("Days of week given by Doomsday rule:")
for (date in dates) {
    var y = Num.fromString(date[0..3])
    var m = Num.fromString(date[5..6]) - 1
    var d = Num.fromString(date[8..9])
    var a = anchorDay.call(y)
    var w = d - (isLeapYear.call(y) ? firstDaysLeap[m] : firstDaysCommon[m])
    if (w < 0) w = 7 + w
    var dow = (a + w) % 7
    System.print("%(date) -> %(days[dow])")
}

System.print("\nDays of week given by Date module:")
for (date in dates) {
    var d = Date.parse(date, Date.isoDate)
    System.print("%(date) -> %(d.weekDay)")
}
