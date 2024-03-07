import "./fmt" for Fmt
import "./date" for Date

var isPalDate = Fn.new { |date|
    date = date.format(Date.rawDate)
    return date == date[-1..0]
}

Date.default = Date.isoDate
System.print("The next 15 palindromic dates in yyyy-mm-dd format after 2020-02-02 are:")
var date = Date.new(2020, 2, 2)
var count = 0
while (count < 15) {
    date = date.addDays(1)
    if (isPalDate.call(date)) {
        System.print(date)
        count = count + 1
    }
}
