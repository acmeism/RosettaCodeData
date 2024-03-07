/* Regular_expressions_2.wren */
import "./regex" for Regex

var s = "This is a story about R2D2 and C3P0 who are best friends."
var re = Regex.compile("""[A-Z]\d[A-Z]\d""")
var matches = re.findAll(s)
var indices = re.findAllIndex(s)
System.print("Original string:\n%("  %(s)")")

System.print("\nThe following matches were found:")
for (i in 0...matches.count) {
    var m = matches[i]
    var ix = indices[i][0]
    System.print("  %(m) at index %(ix)")
}

System.print("\nAfter replacing the second match:")
System.print("  %(re.replaceAll(s, "Luke", 2, 1))") // replace 2nd match with "Luke"

System.print("\nReformatted phone list example:")
var phoneList = [
    "Harry Potter 98951212",
    "Hermione Granger 59867125",
    "Ron Weasley 56471832"
]

var re2 = Regex.compile("""([A-Za-z]+) ([A-Za-z]+) (\d{8})""")
for (record in phoneList) {
    var m = re2.findSubmatch(record)
    System.print("  %(m[2]), %(m[1]) - %(m[3])")
}
