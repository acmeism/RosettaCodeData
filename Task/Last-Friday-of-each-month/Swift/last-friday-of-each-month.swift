import Foundation

func lastFridays(of year: Int) -> [Date] {
	
	let calendar = Calendar.current
	var dates = [Date]()
	
	for month in 2...13 {
		
		let lastDayOfMonth = DateComponents(calendar: calendar,
		                                    year: year,
		                                    month: month,
		                                    day: 0,
		                                    hour: 12)
		
		let date = calendar.date(from: lastDayOfMonth)!
		
		let isFriday = calendar.component(.weekday, from: date) == 6
		
		if isFriday {
			
			dates.append(calendar.date(from: lastDayOfMonth)!)
			
		} else {
			
			let lastWeekofMonth = calendar.ordinality(of: .weekOfMonth,
			                                          in: .month,
			                                          for: date)!
			
			let lastWithFriday = lastWeekofMonth - (calendar.component(.weekday, from: date) > 6 ? 0 : 1)
			
			let lastFridayOfMonth = DateComponents(calendar: calendar,
			                                       year: year,
			                                       month: month - 1,
			                                       hour: 12,
			                                       weekday: 6,
			                                       weekOfMonth: lastWithFriday)
			
			dates.append(calendar.date(from: lastFridayOfMonth)!)
		}
	}
	return dates
}

var dateFormatter = DateFormatter()
dateFormatter.dateStyle = .short

print(lastFridays(of: 2013).map(dateFormatter.string).joined(separator: "\n"))
