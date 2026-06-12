import "./date" for Date

var s1 = "Rosetta "
var s2 = "code"
var s3 = s1 + s2          // + operator used to concatenate two strings
System.print("s3 = %(s3)")

var s4 = "a" * 20         // * operator used to provide string repetition
System.print("s4 = %(s4)")

var l1 = [1, 2, 3] + [4]  // + operator used to concatenate two lists
System.print("l1 = %(l1)")

var l2 = ["a"] * 8        // * operator used to create a new list by repeating another
System.print("l2 = %(l2)")

// the user defined class Date overloads the - operator to provide the interval between two dates
var d1 = Date.new(2021, 9, 11)
var d2 = Date.new(2021, 9, 13)
var i1 = (d2 - d1).days
System.print("i1 = %(i1) days")
