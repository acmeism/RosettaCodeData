import "io" for File
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var count = 0
File.read(wordList).trimEnd().split("\n").
    where { |w|
        return w.count > 10 && "aeiou".all { |v|
            return w.count { |c| c == v } == 1
        }
    }.
    each { |w|
        count = count + 1
        Fmt.print("$2d: $s", count, w)
    }
