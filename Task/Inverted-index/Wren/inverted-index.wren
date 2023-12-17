import "./ioutil" for FileUtil, Input
import "./pattern" for Pattern
import "./str" for Str
import "os" for Process

var invIndex = {}
var fileNames = []
var splitter = Pattern.new("+1/W")

class Location {
    construct new(fileName, wordNum) {
        _fileName = fileName
        _wordNum = wordNum
    }

    toString { "%(_fileName), word number %(_wordNum)" }
}

var indexFile = Fn.new { |fileName|
    if (fileNames.contains(fileName)) {
        System.print("'%(fileName)' already indexed")
        return
    }
    fileNames.add(fileName)
    var lines = FileUtil.readLines(fileName)
    lines.each { |line|
        line = Str.lower(line)
        var i = 0
        for (w in splitter.splitAll(line)) {
            var locations = invIndex[w]
            if (!locations) {
                locations = []
                invIndex[w] = locations
            }
            locations.add(Location.new(fileName, i + 1))
            i = i + 1
        }
    }
    System.print("'%(fileName)' has been indexed")
}

var findWord = Fn.new { |word|
    var w = Str.lower(word)
    var locations = invIndex[w]
    if (locations) {
       System.print("\n'%(word)' found in the following locations:")
       System.print(locations.map { |l| "    %(l)" }.join("\n"))
    } else {
       System.print("\n'%(word)' not found")
    }
    System.print()
}

// files to be indexed entered as command line arguments
var args = Process.arguments
if (args.count == 0) {
    System.print("No file names have been supplied")
    return
}
for (arg in args) indexFile.call(arg)
System.print("\nEnter word(s) to be searched for in these files or 'q' to quit")
while (true) {
    var word = Input.text("  ? : ", 1)
    if (word == "q" || word == "Q") return
    findWord.call(word)
}
