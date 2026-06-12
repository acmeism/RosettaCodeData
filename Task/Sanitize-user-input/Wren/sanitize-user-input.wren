import "./ioutil" for Input
import "./pattern" for Pattern
import "./str" for Str
import "./iterate" for Indexed

class Person {
    construct new(firstName, lastName) {
        _firstName = firstName
        _lastName  = lastName
    }

    firstName { _firstName }
    lastName  { _lastName }

    toString { _firstName + " " + _lastName }
}

var persons = []
var blacklist = [
    "drop", "delete", "erase", "kill", "wipe", "remove",
    "file", "files", "directory", "directories",
    "table", "tables", "record", "records", "database", "databases",
    "system", "system32", "system64", "rm", "rf", "rmdir", "format", "reformat"
]

var punct = "'-" // allowable punctuation
var i = Pattern.letter + punct
var p = Pattern.new("+1&i", Pattern.whole, i)

var sanitizeInput = Fn.new { |name|
    var ok = p.isMatch(name) && !(punct.contains(name[0]) || punct.contains(name[-1]))
    if (!ok) return "Sorry, your name contains unacceptable characters."
    name = Str.lower(name)
    if (blacklist.contains(name)) return "Sorry, your name is unacceptable."
    return ""
}

for (i in 1..20) {
    var names = List.filled(2, null)
    var outer = false
    for (se in Indexed.new(["first", "last "])) {
        var name = Input.text("Enter your %(se.value) name : ", 1, 20)
        var msg = sanitizeInput.call(name)
        if (msg != "") {
            System.print(msg + "\n")
            outer = true
            break
        }
        names[se.index] = name
    }
    if (outer) continue
    persons.add(Person.new(names[0], names[1]))
    System.print()
}
var count = persons.count
System.print("The following %(count) person(s) have been added to the database:")
for (person in persons) System.print(person)
