struct MonthDay: CustomStringConvertible {
  static let months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]

  var month: Int
  var day: Int

  var description: String { "\(MonthDay.months[month - 1]) \(day)" }

  private func isUniqueIn(months: [MonthDay], by prop: KeyPath<MonthDay, Int>) -> Bool {
    return months.lazy.filter({ $0[keyPath: prop] == self[keyPath: prop] }).count == 1
  }

  func monthIsUniqueIn(months: [MonthDay]) -> Bool {
    return isUniqueIn(months: months, by: \.month)
  }

  func dayIsUniqueIn(months: [MonthDay]) -> Bool {
    return isUniqueIn(months: months, by: \.day)
  }

  func monthWithUniqueDayIn(months: [MonthDay]) -> Bool {
    return months.firstIndex(where: { $0.month == month && $0.dayIsUniqueIn(months: months) }) != nil
  }
}

let choices = [
  MonthDay(month: 5, day: 15),
  MonthDay(month: 5, day: 16),
  MonthDay(month: 5, day: 19),
  MonthDay(month: 6, day: 17),
  MonthDay(month: 6, day: 18),
  MonthDay(month: 7, day: 14),
  MonthDay(month: 7, day: 16),
  MonthDay(month: 8, day: 14),
  MonthDay(month: 8, day: 15),
  MonthDay(month: 8, day: 17)
]

// Albert knows the month, but not the day, so he doesn't have a gimmie month
let albertKnows = choices.filter({ !$0.monthIsUniqueIn(months: choices) })

// Albert also knows that Bernard doesn't know, so it can't be a gimmie day
let bernardKnows = albertKnows.filter({ !$0.monthWithUniqueDayIn(months: albertKnows) })

// Bernard now knows the birthday, so it must be a unique day within the remaining choices
let bernardKnowsMore = bernardKnows.filter({ $0.dayIsUniqueIn(months: bernardKnows) })

// Albert knows the birthday now, so it must be a unique month within the remaining choices
guard let birthday = bernardKnowsMore.filter({ $0.monthIsUniqueIn(months: bernardKnowsMore) }).first else {
  fatalError()
}

print("Cheryl's birthday is \(birthday)")
