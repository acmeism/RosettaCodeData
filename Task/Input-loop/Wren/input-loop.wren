import "io" for File

File.open("input.txt") { |file|
    var offset = 0
    var line = ""
    while(true) {
        var b = file.readBytes(1, offset)
        offset = offset + 1
        if (b == "\n") {
            // process 'line'
            line = "" // reset line variable
        } else if (b == "\r") { // Windows
            // wait for following "\n"
        } else if (b == "") { // end of stream
            return
        } else {
            line = line + b
        }
    }
}
