import Foundation
extension String {
    func toStandardDateWithDateFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.dateStyle = .LongStyle
        return dateFormatter.stringFromDate(dateFormatter.dateFromString(self)!)
    }
}

let date = "2015-08-28".toStandardDateWithDateFormat("yyyy-MM-dd")
