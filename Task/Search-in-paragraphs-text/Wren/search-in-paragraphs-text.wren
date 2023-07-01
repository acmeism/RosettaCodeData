import "io" for File
import "./pattern" for Pattern

var fileName = "Traceback.txt"
var p1 = Pattern.new("Traceback (most recent call last):")
var p2 = Pattern.new("SystemError")
var sep = "----------------"

File.read(fileName)
    .split("\n\n")
    .where { |para| p1.isMatch(para) && p2.isMatch(para) }
    .each { |para|
        var ix = p1.find(para).index
        System.print(para[ix..-1])
        System.print(sep)
    }
