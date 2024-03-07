import "./fmt" for Conv, Fmt
import "./sort" for Sort

var games = ["12", "13", "14", "23", "24", "34"]
var results = "000000"

var nextResult = Fn.new {
    if (results == "222222") return false
    var res = Conv.atoi(results, 3) + 1
    results = Fmt.swrite("$06t", res)
    return true
}

var points = List.filled(4, null)
for (i in 0..3) points[i] = List.filled(10, 0)
while (true) {
    var records = List.filled(4, 0)
    for (i in 0..5) {
        var g0 = Num.fromString(games[i][0]) - 1
        var g1 = Num.fromString(games[i][1]) - 1
        if (results[i] == "2") {
            records[g0] = records[g0] + 3
        } else if (results[i] == "1") {
            records[g0] = records[g0] + 1
            records[g1] = records[g1] + 1
        } else if (results[i] == "0") {
            records[g1] = records[g1] + 3
        }
    }
    Sort.insertion(records)
    for (i in 0..3) points[i][records[i]] = points[i][records[i]] +1
    if (!nextResult.call()) break
}
System.print("POINTS           0    1    2    3    4    5    6    7    8    9")
System.print("---------------------------------------------------------------")
for (i in 0..3) {
    Fmt.write("$r place    ", i+1)
    points[3-i].each { |p| Fmt.write("$5d", p) }
    System.print()
}
