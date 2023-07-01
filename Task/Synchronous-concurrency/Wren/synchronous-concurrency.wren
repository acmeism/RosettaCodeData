import "io" for File

var EOT = "\x04"

var readLines = Fiber.new { |fileName|
    var file = File.open(fileName)
    var offset = 0
    var line = ""
    while (true) {
        var b = file.readBytes(1, offset)
        offset = offset + 1
        if (b == "\n") {
            Fiber.yield(line)
            line = "" // reset line variable
        } else if (b == "\r") { // Windows
            // wait for following "\n"
        } else if (b == "") { // end of stream
            var numLines = Fiber.yield(EOT)
            System.print("Number of lines read = %(numLines)")
            break
        } else {
            line = line + b
        }
    }
    file.close()
}

var numLines = 0
while(true) {
    var line = readLines.call("input.txt")
    if (line != EOT) {
        System.print(line)
        numLines = numLines + 1
    } else {
        readLines.call(numLines)
        break
    }
}
