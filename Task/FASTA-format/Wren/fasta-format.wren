import "io" for File

var checkNoSpaces = Fn.new { |s| !s.contains(" ") && !s.contains("\t") }

var first = true

var process = Fn.new { |line|
    if (line[0] == ">") {
        if (!first) System.print()
        System.write("%(line[1..-1]): ")
        if (first) first = false
    } else if (first) {
        Fiber.abort("File does not begin with '>'.")
    } else if (checkNoSpaces.call(line)) {
        System.write(line)
    } else {
        Fiber.abort("Sequence contains space(s).")
    }
}

var fileName = "input.fasta"
File.open(fileName) { |file|
    var offset = 0
    var line = ""
    while(true) {
        var b = file.readBytes(1, offset)
        offset = offset + 1
        if (b == "\n") {
            process.call(line)
            line = "" // reset line variable
        } else if (b == "\r") { // Windows
            // wait for following "\n"
        } else if (b == "") { // end of stream
            System.print()
            return
        } else {
            line = line + b
        }
    }
}
