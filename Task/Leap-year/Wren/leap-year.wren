var isLeapYear = Fn.new { |y|
    return ((y % 4 == 0) && (y % 100!= 0)) || (y % 400 == 0)
}

System.print("Leap years between 1900 and 2020 inclusive:")
var c = 0
for (i in 1900..2020) {
    if (isLeapYear.call(i)) {
        System.write("%(i) ")
        c = c + 1
        if (c % 15 == 0) System.print()
    }
}
