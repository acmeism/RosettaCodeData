import "os" for Platform
import "io" for File

var removeLines = Fn.new { |fileName, startLine, numLines|
    if (fileName == "" || startLine < 1 || numLines < 1) Fiber.abort("Invalid argument(s).")
    if (!File.exists(fileName)) Fiber.abort("Can't find %(fileName).")
    var text = File.read(fileName)
    System.print("Contents of %(fileName) before removal:\n%(text)")
    var sep = Platform.isWindows ? "\r\n" : "\n"
    var lines = text.split(sep)
    var size = lines.count
    if (startLine > size) {
        System.print("The starting line is beyond the length of the file.")
        return
    }
    var n = numLines
    if (startLine + numLines - 1 > size) {
        System.print("Attempting to remove some lines which are beyond the end of the file.")
        n = size - startLine + 1
    }
    lines = lines.take(startLine - 1).toList + lines.skip(startLine + n - 1).toList
    text = lines.join(sep)
    File.create(fileName) { |file| // effectively overwrites the file
        file.writeBytes(text)
    }
    System.print("Contents of %(fileName) after removal of %(numLines) lines starting from line %(startLine):")
    System.print(File.read(fileName))
}

removeLines.call("foobar.txt", 2, 3)
