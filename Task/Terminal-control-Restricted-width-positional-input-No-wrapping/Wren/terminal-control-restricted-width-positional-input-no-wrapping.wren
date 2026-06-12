import "./ansi" for Screen, Cursor
import "io" for Stdin

var input = Fn.new { |r, c, maxWidth|
    Screen.clear()
    Cursor.move(r, c)
    Stdin.isRaw = true
    var w = 0
    var res = List.filled(maxWidth, "")
    while (true) {
        var byte = Stdin.readByte()
        if (byte >= 32 && byte < 127) {        // All printable ASCII characters
            var char = String.fromByte(byte)
            Cursor.move(r, c+w)
            Screen.fwrite(char)
            if (w < maxWidth-1) {
                res[w] = char
                w = w + 1
            } else {
                Screen.fwrite("\b")
                res[w] = char
            }
        } else if (byte == 127 && w > 0) {     // Backspace/delete (127 used rather than 8)
            if (w < maxWidth-1) {
                Screen.fwrite("\b \b")
            } else {
                Screen.fwrite("\b  \b\b")
                res[w] = ""
            }
            w = w - 1
            res[w]= ""
        } else if (byte == 13 || byte == 10) { // Carriage return or line feed
            System.print()
            break
        } else if (byte == 3 || byte == 4) {   // Ctrl-C or Ctrl-D
            Stdin.isRaw = false
            Fiber.abort("\nScript aborted.")
        }
    }
    Stdin.isRaw = false
    return res.join().trimEnd(" ")
}

var res = input.call(3, 5, 8)
System.print(res)
