func isLeapYear(year:Int) -> Bool {
   return (year % 100 == 0) ? (year % 400 == 0) : (year % 4 == 0)
}

println(isLeapYear(2000))
println(isLeapYear(2011))
