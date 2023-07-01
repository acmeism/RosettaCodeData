func isLeapYear(year: Int) -> Bool {
    return year.isMultiple(of: 100) ? year.isMultiple(of: 400) : year.isMultiple(of: 4)
}

[1900, 1994, 1996, 1997, 2000].forEach { year in
    print("\(year): \(isLeapYear(year: year) ? "YES" : "NO")")
}
