import "io" for File
import "./ioutil" for FileUtil
import "./str" for Str
import "./seq" for Lst

var merge2 = Fn.new { |inputFile1, inputFile2, outputFile|
    // Note that the FileUtil.readEachLine method checks the file exists and closes it
    // when there are no more lines to read.
    var reader1 = Fiber.new(FileUtil.readEachLine(inputFile1))
    var reader2 = Fiber.new(FileUtil.readEachLine(inputFile2))
    var writer = File.create(outputFile)
    var line1 = reader1.call()
    var line2 = reader2.call()
    while (line1 && line2) {
        if (Str.le(line1, line2)) {
            writer.writeBytes(line1 + "\n")
            line1 = reader1.call()
        } else {
            writer.writeBytes(line2 + "\n")
            line2 = reader2.call()
        }
    }
    while (line1) {
       writer.writeBytes(line1 + "\n")
       line1 = reader1.call()
    }
    while (line2) {
       writer.writeBytes(line2 + "\n")
       line2 = reader2.call()
    }
    writer.close()
}

var mergeN = Fn.new { |inputFiles, outputFile|
    var readers = inputFiles.map { |f| Fiber.new(FileUtil.readEachLine(f)) }.toList
    var writer = File.create(outputFile)
    var lines = readers.map { |reader| reader.call() }.toList
    while (lines.any { |line| line }) {
        var line = lines.where { |line| line }.reduce() { |acc, s| Str.lt(s, acc) ? s : acc }
        var index = Lst.indexOf(lines, line)
        writer.writeBytes(line + "\n")
        lines[index] = readers[index].call()
    }
    writer.close()
}

var files = ["merge1.txt", "merge2.txt", "merge3.txt", "merge4.txt"]
merge2.call(files[0], files[1], "merged2.txt")
mergeN.call(files, "mergedN.txt")
// check it worked
System.print(File.read("merged2.txt"))
System.print(File.read("mergedN.txt"))
