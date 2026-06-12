import "./date" for Date

System.print("Days of week per Gregorian Proleptic calendar:")
var years = [1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393]
for (year in years) {
    var newYear = Date.new(year, 1, 1).weekDay
    var xmas = Date.new(year, 12, 25).weekDay
    System.print("  In %(year), New year's day is on a %(newYear), and Christmas day on %(xmas).")
}
System.print("\nActual days for 1578 (Julian calendar) were 10 days later:")
System.print("  New Year's day was on %(Date.fromJulian(1578, 1, 1).weekDay), and Christmas day on %(Date.fromJulian(1578, 12, 25).weekDay).")
