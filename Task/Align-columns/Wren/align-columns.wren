import "io" for File
import "./fmt" for Fmt

var LEFT = 0
var RIGHT = 1
var CENTER = 2
var justStrs = ["LEFT", "RIGHT", "CENTER"]

// Gets a list of lines in the file with each line split into fields.
var getLines = Fn.new { |fileName|
    var contents = File.read(fileName)
    var lines = contents.split("\n") // use "\r\n" on Windows
    for (i in 0...lines.count) {
        lines[i] = lines[i].trim().trimEnd("$")
        if (lines[i] == "") { // get rid of final blank line, if any
            lines = lines[0..-2]
            break
        }
        lines[i] = lines[i].split("$")
    }
    return lines
}

var alignCols = Fn.new { |lines, just|
    // find maximum number of columns
    var nCols = lines.reduce(0) { |acc, line| (line.count > acc) ? line.count : acc }
    // find maximum width for each column
    var maxWids = List.filled(nCols, 0)
    for (line in lines) {
        for (i in 0...line.count) {
            var width = line[i].count
            if (width > maxWids[i]) maxWids[i] = width
        }
    }
    System.print("With %(justStrs[just]) justification:")
    for (line in lines) {
        for (i in 0...line.count) {
            var width = maxWids[i] + 1
            if (just == LEFT) {
                System.write(Fmt.s(-width, line[i]))
            } else if (just == RIGHT) {
                System.write(Fmt.s(width, line[i]))
            } else if (just == CENTER) {
                System.write(Fmt.m(width, line[i]))
            }
        }
        System.print()
    }
    System.print()
}

var fileName = "align_cols.txt"
var lines = getLines.call(fileName)
for (i in 0..2) alignCols.call(lines, i)
