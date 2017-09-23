func isLeapYear(year:Int) -> Bool {
   return (year % 100 == 0) ? (year % 400 == 0) : (year % 4 == 0)
}

print(isLeapYear(2000))
print(isLeapYear(2011))
