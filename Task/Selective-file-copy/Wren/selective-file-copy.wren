import "io" for File
import "./ioutil" for FileUtil
import "./fmt" for Fmt

var process = Fn.new { |line|
    var a = line[0...5]
    var n = Num.fromString(line[14] + line[10...14])
    return Fmt.swrite("$s$5dXXXXX", a, n)
}

var lb = FileUtil.lineBreak
File.create("selective_output.txt") { |f|
    var first = true
    File.read("selective_input.txt").trim().split(lb).each { |line|
        if (!first) f.writeBytes(lb)
        f.writeBytes(process.call(line))
        if (first) first = false
    }
}
// check it worked
System.print(File.read("selective_output.txt"))
