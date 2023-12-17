import "./date" for Date

var fmt = "mmmm| |d| |yyyy| |H|:|MM|am| |zz|"
var d = Date.parse("March 7 2009 7:30pm EST", fmt)
Date.default = fmt
System.print("Original date/time : %(d)")
d = d.addHours(12)
System.print("12 hours later     : %(d)")
// Adjust to MST say
d = d.adjustTime("MST")
System.print("Adjusted to MST    : %(d)")
