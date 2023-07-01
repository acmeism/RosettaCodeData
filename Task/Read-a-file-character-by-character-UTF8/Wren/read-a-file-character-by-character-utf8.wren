import "io" for File

File.open("input.txt") { |file|
    var offset = 0
    var char = "" // stores each byte read till we have a complete UTF encoded character
    while(true) {
        var b = file.readBytes(1, offset)
        if (b == "") return // end of stream
        char = char + b
        if (char.codePoints[0] >= 0) {  // a UTF encoded character is complete
            System.write(char)          // print it
            char = ""                   // reset store
        }
        offset = offset + 1
    }
}
