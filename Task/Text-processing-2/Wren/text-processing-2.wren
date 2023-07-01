import "io" for File
import "/pattern" for Pattern
import "/fmt" for Fmt
import "/sort" for Sort

var p = Pattern.new("+1/s")
var fileName = "readings.txt"
var lines = File.read(fileName).trimEnd().split("\r\n")
var count = 0
var invalid = 0
var allGood = 0
var map = {}
for (line in lines) {
    count = count + 1
    var fields = p.splitAll(line)
    var date = fields[0]
    if (fields.count == 49) {
        map[date] = map.containsKey(date) ? map[date] + 1 : 1
        var good = 0
        var i = 2
        while (i < fields.count) {
            if (Num.fromString(fields[i]) >= 1) good = good + 1
            i = i + 2
        }
        if (good == 24) allGood = allGood + 1
    } else {
        invalid = invalid + 1
   }
}

Fmt.print("File = $s", fileName)
System.print("\nDuplicated dates:")
var keys = map.keys.toList
Sort.quick(keys)
for (k in keys) {
    var v = map[k]
    if (v > 1) Fmt.print("  $s  ($d times)", k, v)
}
Fmt.print("\nTotal number of records   : $d", count)
var percent = invalid/count * 100
Fmt.print("Number of invalid records : $d ($5.2f)\%", invalid, percent)
percent = allGood/count * 100
Fmt.print("Number which are all good : $d ($5.2f)\%", allGood, percent)
