import Cocoa

var year=2008
let formatter=DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"

let gregorian:NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
while (year<2122){
    var date:NSDate!=formatter.date(from: String(year)+"-12-25") as NSDate?
    var components=gregorian.components(NSCalendar.Unit.weekday, from: date as Date)
    var dayOfWeek:NSInteger=components.weekday!
    if(dayOfWeek==1){
        print(year)
    }
    year+=1
}
