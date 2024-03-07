import "io" for File
import "./pattern" for Pattern
import "./fmt" for Fmt

var p = Pattern.new("+1/s")
var fileName = "readings.txt"
var lines = File.read(fileName).trimEnd().split("\r\n")
var f = "Line:  $s  Reject: $2d  Accept: $2d  Line_tot: $8.3f  Line_avg: $7.3f"
var grandTotal = 0
var readings = 0
var date = ""
var run = 0
var maxRun = -1
var finishLine = ""
for (line in lines) {
    var fields = p.splitAll(line)
    date = fields[0]
    if (fields.count == 49) {
        var accept = 0
        var total = 0
        var i = 1
        while (i < fields.count) {
            if (Num.fromString(fields[i+1]) >= 1) {
                accept = accept + 1
                total = total + Num.fromString(fields[i])
                if (run > maxRun) {
                    maxRun = run
                    finishLine = date
                }
                run = 0
            } else {
                run = run + 1
            }
            i = i + 2
        }
        grandTotal = grandTotal + total
        readings = readings + accept
        Fmt.print(f, date, 24-accept, accept, total, total/accept)
    } else {
        Fmt.print("Line:  $s does not have 49 fields and has been ignored", date)
    }
}

if (run > maxRun) {
    maxRun = run
    finishLine = date
}
var average = grandTotal / readings
Fmt.print("\nFile     = $s", fileName)
Fmt.print("Total    = $0.3f", grandTotal)
Fmt.print("Readings = $d", readings)
Fmt.print("Average  = $0.3f", average)
Fmt.print("\nMaximum run of $d consecutive false readings", maxRun)
Fmt.print("ends at line starting with date: $s", finishLine)
