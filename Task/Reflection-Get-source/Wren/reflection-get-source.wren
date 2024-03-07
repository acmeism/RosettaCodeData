import "os" for Platform, Process
import "io" for File
import "/.pattern" for Pattern

var getSourceLines = Fn.new {
    var fileName = Process.allArguments[1]
    var text = File.read(fileName)
    var sep = Platform.isWindows ? "\r\n" : "\n"
    return [fileName, text.split(sep)]
}

var res = getSourceLines.call()
var fileName = res[0]
var lines = res[1]
// look for getSourceLines function
var funcName = "getSourceLines"
var p = Pattern.new("+1/s")
var i = 1
var found = 0
for (line in lines) {
    var t = p.splitAll(line.trim())
    if (t[0] == "var" && t[1] == funcName && t[2] == "=" && t[3] == "Fn.new") {
        found = i
        break
    }
    i = i + 1
}

System.print("File name     : %(fileName)")
System.print("Function name : %(funcName)")
System.print("Line number   : %(found > 0 ? found : "Function not found")")
