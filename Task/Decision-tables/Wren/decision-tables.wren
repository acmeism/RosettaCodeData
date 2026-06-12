import "io" for Stdin, Stdout
import "./str" for Str

var conditions = [
    ["Printer prints"                   , "NNNNYYYY"],
    ["A red light is flashing"          , "YYNNYYNN"],
    ["Printer is recognized by computer", "NYNYNYNY"]
]

var actions = [
    ["Check the power cable"               , "NNYNNNNN"],
    ["Check the printer-computer cable"    , "YNYNNNNN"],
    ["Ensure printer software is installed", "YNYNYNYN"],
    ["Check/replace ink"                   , "YYNNNYNN"],
    ["Check for paper jam"                 , "NYNYNNNN"]
]

var nc = conditions.count
var na = actions.count
var nr = conditions[0][1].count  // number of rules
var np = 7  // index of 'no problem' rule
System.print("Please answer the following questions with a y or n:")
var answers = List.filled(nc, false)
for (c in 0...nc) {
    var input
    while (true) {
        System.write("  %(conditions[c][0]) ? ")
        Stdout.flush()
        input = Str.upper(Stdin.readLine())
        if (input == "Y" || input == "N") break
    }
    answers[c] = (input == "Y")
}
System.print("\nRecommended action(s):")
for (r in 0...nr) {
    var outer = false
    for (c in 0...nc) {
        var yn = answers[c] ? "Y" : "N"
        if (conditions[c][1][r] != yn) {
            outer = true
            break
        }
    }
    if (!outer) {
        if (r == np) {
            System.print("  None (no problem detected)")
        } else {
            for (a in 0...na) {
                if (actions[a][1][r] == "Y") System.print("  %(actions[a][0])")
            }
        }
        break
    }
}
