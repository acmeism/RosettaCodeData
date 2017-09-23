import Foundation

func lastSundays(of year: Int) -> [Date] {
	
	let calendar = Calendar.current
	var dates = [Date]()
	
	for month in 1...12 {
		
		var dateComponents = DateComponents(calendar: calendar,
		                                    year: year,
		                                    month: month + 1,
		                                    day: 0,
		                                    hour: 12)
		
		let date = calendar.date(from: dateComponents)!
		let weekday = calendar.component(.weekday, from: date)

		if weekday != 1 {
			dateComponents.day! -= weekday - 1
		}
		
		dates.append(calendar.date(from: dateComponents)!)
	}
	return dates
}

var dateFormatter = DateFormatter()
dateFormatter.dateStyle = .short

print(lastSundays(of: 2013).map(dateFormatter.string).joined(separator: "\n"))
