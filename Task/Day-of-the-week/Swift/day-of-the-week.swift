import Cocoa

var year=2008
let formatter=NSDateFormatter()
formatter.dateFormat = "yyyy-MM-dd"

let gregorian:NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
while (year<2122){
    var date:NSDate!=formatter.dateFromString(String(year)+"-12-25")
    var components=gregorian.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date)
    var dayOfWeek:NSInteger=components.weekday
    if(dayOfWeek==1){
        println(year)
    }
    year++
}
