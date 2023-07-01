import Foundation

let formatter = DateFormatter()

formatter.dateFormat = "MMMM dd yyyy hh:mma zzz"

guard let date = formatter.date(from: "March 7 2009 7:30pm EST") else {
  fatalError()
}

print(formatter.string(from: date))
print(formatter.string(from: date + 60 * 60 * 12))
