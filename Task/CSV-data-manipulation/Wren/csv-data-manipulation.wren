import "io" for File

var lines = File.read("rc.csv").split("\n").map { |w| w.trim() }.toList

var file = File.create("rc.csv") // overwrite existing file
file.writeBytes(lines[0] + ",SUM\n")
for (line in lines.skip(1)) {
    if (line != "") {
        var nums = line.split(",").map { |s| Num.fromString(s) }
        var sum = nums.reduce { |acc, n| acc + n }
        file.writeBytes(line + ",%(sum)\n")
    }
}
file.close()
