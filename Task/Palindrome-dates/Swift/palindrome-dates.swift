import Foundation

func isPalindrome(_ string: String) -> Bool {
    let chars = string.lazy
    return chars.elementsEqual(chars.reversed())
}

let format = DateFormatter()
format.dateFormat = "yyyyMMdd"

let outputFormat = DateFormatter()
outputFormat.dateFormat = "yyyy-MM-dd"

var count = 0
let limit = 15
let calendar = Calendar.current
var date = Date()

while count < limit {
    if isPalindrome(format.string(from: date)) {
        print(outputFormat.string(from: date))
        count += 1
    }
    date = calendar.date(byAdding: .day, value: 1, to: date)!
}
