import "./ioutil" for File, FileUtil

var fileName1 = "rodgers.txt"
var fileName2 = "rodgers_reversed.txt"

// read lines from input file
var lines  = FileUtil.readLines(fileName1)
// remove final blank line, if any, added by some editors
if (lines[-1] == "") lines.removeAt(-1)

// write lines in reverse order to output file
File.create(fileName2) { |file|
    for (i in lines.count-1..1) file.writeBytes(lines[i] + FileUtil.lineBreak)
    file.writeBytes(lines[0])
}
// print contents of output file to terminal
System.print(File.read(fileName2))
