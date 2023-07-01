import "io" for File

var lines = File.read("input.txt").replace("\r", "").split("\n")
if (lines.count < 7) {
    System.print("There are only %(lines.count) lines in the file")
} else {
    var line7 = lines[6].trim()
    if (line7 == "") {
        System.print("The seventh line is empty")
    } else {
        System.print("The seventh line is : %(line7)")
    }
}

/* Note that 'input.txt' contains the eight lines:
Line 1
Line 2
Line 3
Line 4
Line 5
Line 6
Line 7
Line 8
*/
