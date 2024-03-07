import "./pattern" for Pattern

var s = "This is a story about R2D2 and C3P0 who are best friends."
var p = Pattern.new("/u/d/u/d")
var matches = p.findAll(s)
System.print("Original string:\n%("  %(s)")")

System.print("\nThe following matches were found:")
matches.each{ |m| System.print("  %(m.text) at index %(m.index)") }

System.print("\nAfter replacing the second match:")
System.print("  %(p.replace(s, "Luke", 2, 1))") // replace 2nd match with "Luke"

System.print("\nReformatted phone list example:")
var phoneList = [
    "Harry Potter 98951212",
    "Hermione Granger 59867125",
    "Ron Weasley 56471832"
]
var p2 = Pattern.new("[+1/a] [+1/a] [=8/d]")
for (record in phoneList) {
    var m = p2.find(record)
    var t = m.capsText
    System.print("  %(t[1]), %(t[0]) - %(t[2])")
}
