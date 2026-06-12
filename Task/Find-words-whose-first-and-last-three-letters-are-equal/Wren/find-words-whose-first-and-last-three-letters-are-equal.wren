import "io" for File
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var count = 0
File.read(wordList).trimEnd().split("\n").
    where { |w|
        return w.count > 5 && (w[0..2] == w[-3..-1])
    }.
    each { |w|
        count = count + 1
        Fmt.print("$d: $s", count, w)
    }
