import "os" for Platform, Process
import "io" for File

var clipboard = "" // don't have access to real thing

var interpret = Fn.new { |source|
    var source2 = source
    if (Platform.isWindows) source2 = source.replace("\r\n", "\n")
    var lines = source2.split("\n")
    var le = lines.count
    var i = 0
    while (i < le) {
        lines[i] = lines[i].trim() // ignore leading & trailing whitespace
        if (lines[i] == "Copy") {
            if (i == le - 1) Fiber.abort("There are no lines after the Copy command.")
            i = i + 1
            clipboard = lines[i]
        } else if (lines[i] == "CopyFile") {
            if (i == le - 1) Fiber.abort("There are no lines after the CopyFile command.")
            i = i + 1
            if (lines[i] == "TheF*ckingCode") {
                clipboard = source
            } else {
                var s = File.read(lines[i])
                clipboard = s
            }
        } else if (lines[i] == "Duplicate") {
            if (i == le - 1) Fiber.abort("There are no lines after the Duplicate command.")
            i = i + 1
            var times = Num.fromString(lines[i])
            if (times < 0) Fiber.abort("Can't duplicate text a negative number of times.")
            var text = clipboard
            clipboard = text * (times + 1)
        } else if (lines[i] == "Pasta!") {
            var text = clipboard
            System.print(text)
            return
        } else {
            if (lines[i] == "") {
                i = i + 1
                continue  // ignore blank lines
            }
            Fiber.abort("Unknown command, %(lines[i])")
        }
        i = i + 1
    }
}

var args = Process.arguments
if (args.count != 1) {
    Fiber.abort("There should be exactly one command line argument, the CopyPasta file path.")
}
var s = File.read(args[0])
interpret.call(s)
