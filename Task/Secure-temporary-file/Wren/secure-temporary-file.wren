import "random" for Random
import "./ioutil" for File, FileUtil
import "./fmt" for Fmt

var rand = Random.new()

var createTempFile = Fn.new { |lines|
    var tmp
    while (true) {
        // create a name which includes a random 6 digit number
        tmp = "/tmp/temp%(Fmt.swrite("$06d", rand.int(1e6))).tmp"
        if (!File.exists(tmp)) break
    }
    FileUtil.writeLines(tmp, lines)
    return tmp
}

var lines = ["one", "two", "three"]
var tmp = createTempFile.call(lines)
System.print("Temporary file path: %(tmp)")
System.print("Original contents of temporary file:")
System.print(File.read(tmp))

// append some more lines
var lines2 = ["four", "five", "six"]
FileUtil.appendLines(tmp, lines2)
System.print("Updated contents of temporary file:")
System.print(File.read(tmp))
File.delete(tmp)
System.print("Temporary file deleted.")
