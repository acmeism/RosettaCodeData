import "./ioutil" for FileUtil
import "./str" for Str

// These could be given as command line arguments
// but we hard-code them for the purposes of this task.
var fileName1 = "test.csv"
var fileName2 = "test.tsv"

// This next line assumes a line break of "\r\n" for Windows or "\n" otherwise.
var lines = FileUtil.readLines(fileName1)

// Get rid of an empty last line if there is one.
if (lines.count > 1 && lines[-1] == "") lines = lines[0...-1]

var lc = lines.count

// Normalize fields before rejoining with \t.
for (i in 0...lc) {
    // Str.splitCSv treats quoted fields by default as unquoted if there's any
    // leading whitespace but we can't do that here.
    var fields = Str.splitCsv(lines[i], ",", false)
    for (i in 0...fields.count) {
        var numQuotes = fields[i].count { |c| c == "\"" }
        // Treat it as a quoted field for this task if there's at least two quotes
        // and then remove any surrounding whitespace and the outer quotes.
        if (numQuotes > 1) fields[i] = fields[i].trim().trim("\"")

        fields[i] = fields[i].replace("\"\"", "\"")
                             .replace("\\t", "\\\\t")
                             .replace("\\r", "\\\\r")
                             .replace("\\n", "\\\\n")
                             .replace("\t", "\\t")
                             .replace("\n", "\\n")
                             .replace("\r", "\\r")
                             .replace("\0", "\\0")
    }
    // Not sure how 'nonsense' is defined but for now blank
    // the final field if it contains nothing but quotes.
    if (fields[-1].count > 0 && fields[-1].all { |c| c == "\"" }) fields[-1] = ""
    lines[i] = fields.join("\t")
}

// Write lines (as amended) to fileName2.
FileUtil.writeLines(fileName2, lines)

// Write contents of fileName2 to the terminal with tabs replaced by <tab> and
// with each line surrounded with single quotes.
lines = FileUtil.readLines(fileName2)[0...-1]
                .map { |line| "'%(line)'".replace("\t", "<tab>") }
                .join("\n")
System.print(lines)
