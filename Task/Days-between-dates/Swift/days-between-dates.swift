import Foundation

func daysFromTimeInterval(_ interval: Double) -> Int {
  return Int(interval) / 86400
}

let formatter = DateFormatter()

formatter.dateFormat = "yyyy-MM-dd"

print("Enter date one (yyyy-MM-dd): ", terminator: "")

guard let date1Str = readLine(strippingNewline: true), let date1 = formatter.date(from: date1Str) else {
  fatalError("Invalid date two")
}

print("Enter date two (yyyy-MM-dd): ", terminator: "")

guard let date2Str = readLine(strippingNewline: true), let date2 = formatter.date(from: date2Str) else {
  fatalError("Invalid date two")
}

let (start, end) = date1 > date2 ? (date2, date1) : (date1, date2)
let days = daysFromTimeInterval(DateInterval(start: start, end: end).duration)

print("There are \(days) days between \(start) and \(end)")
