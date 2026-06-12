import "./ansi" for Screen, Cursor
import "io" for Stdin

var input = Fn.new { |r, c, maxWidth|
    Screen.clear()
    Cursor.move(r, c)
    Stdin.isRaw = true
    var res = ""
    var blank = " " * (maxWidth-1)
    while (true) {
        var byte = Stdin.readByte()
        if (byte >= 32 && byte < 127) {        // All printable ASCII characters
            var char = String.fromByte(byte)
            res = res + char
            var count = res.count
            Cursor.move(r, c)
            if (count <= maxWidth-1) {
                Screen.fwrite(res)
            } else {
                Screen.fwrite(res[-maxWidth+1..-1])
            }
        } else if (byte == 127 && res.count > 0) {     // Backspace/delete (127 used rather than 8)
            res = res[0...-1]
            var count = res.count
            Cursor.move(r, c)
            if (count <= maxWidth-1) {
                Screen.fwrite(blank)
                Cursor.move(r, c)
                Screen.fwrite(res)
            } else {
                Screen.fwrite(res[-maxWidth+1..-1])
            }
        } else if (byte == 13 || byte == 10) { // Carriage return or line feed
            System.print()
            break
        } else if (byte == 3 || byte == 4) {   // Ctrl-C or Ctrl-D
            Stdin.isRaw = false
            Fiber.abort("\nScript aborted.")
        }
    }
    Stdin.isRaw = false
    return res
}

var res = input.call(3, 5, 8)
System.print(res)
