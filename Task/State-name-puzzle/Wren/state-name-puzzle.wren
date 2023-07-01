import "/str" for Str
import "/sort" for Sort
import "/fmt" for Fmt

var solve = Fn.new { |states|
    var dict = {}
    for (state in states) {
        var key = Str.lower(state).replace(" ", "")
        if (!dict[key]) dict[key] = state
    }
    var keys = dict.keys.toList
    Sort.quick(keys)
    var solutions = []
    var duplicates = []
    for (i in 0...keys.count) {
        for (j in i+1...keys.count) {
            var len = keys[i].count + keys[j].count
            var chars = (keys[i] + keys[j]).toList
            Sort.quick(chars)
            var combined = chars.join()
            for (k in 0...keys.count) {
                for (l in k+1...keys.count) {
                    if (k != i && k != j && l != i && l != j) {
                        var len2 = keys[k].count + keys[l].count
                        if (len2 == len) {
                            var chars2 = (keys[k] + keys[l]).toList
                            Sort.quick(chars2)
                            var combined2 = chars2.join()
                            if (combined == combined2) {
                                var f1 = "%(dict[keys[i]]) + %(dict[keys[j]])"
                                var f2 = "%(dict[keys[k]]) + %(dict[keys[l]])"
                                var f3 = "%(f1) = %(f2)"
                                if (!duplicates.contains(f3)) {
                                    solutions.add(f3)
                                    var f4 = "%(f2) = %(f1)"
                                    duplicates.add(f4)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Sort.quick(solutions)
    var i = 0
    for (sol in solutions) {
        Fmt.print("$2d  $s", i + 1, sol)
        i = i + 1
    }
}

var states = [
    "Alabama", "Alaska", "Arizona", "Arkansas",
    "California", "Colorado", "Connecticut",
    "Delaware",
    "Florida", "Georgia", "Hawaii",
    "Idaho", "Illinois", "Indiana", "Iowa",
    "Kansas", "Kentucky", "Louisiana",
    "Maine", "Maryland", "Massachusetts", "Michigan",
    "Minnesota", "Mississippi", "Missouri", "Montana",
    "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon",
    "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas",
    "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming"
]
System.print("Real states only:")
solve.call(states)
System.print()
var fictitious = [ "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"  ]
System.print("Real and fictitious states:")
solve.call(states + fictitious)
