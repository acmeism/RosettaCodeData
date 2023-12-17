import "io" for Directory, File, Stat
import "os" for Process
import "./math" for Math
import "./fmt" for Fmt

var sizes = List.filled(12, 0)
var totalSize = 0
var numFiles = 0
var numDirs = 0

var fileSizeDist // recursive function
fileSizeDist = Fn.new { |path|
    var files = Directory.list(path)
    for (file in files) {
        var path2 = "%(path)/%(file)"
        var stat = Stat.path(path2)
        if (stat.isFile) {
            numFiles = numFiles + 1
            var size = stat.size
            if (size == 0) {
                sizes[0] = sizes[0] + 1
            } else {
                totalSize = totalSize + size
                var logSize = Math.log10(size)
                var index = logSize.floor + 1
                sizes[index] = sizes[index] + 1
            }
        } else if (stat.isDirectory) {
            numDirs = numDirs + 1
            fileSizeDist.call(path2)
        }
    }
}

var args = Process.arguments
var path = (args.count == 0) ? "./" : args[0]
if (!Directory.exists(path)) Fiber.abort("Path does not exist or is not a directory.")
fileSizeDist.call(path)

System.print("File size distribution for '%(path)' :-\n")
for (i in 0...sizes.count) {
    System.write((i == 0) ? "  " : "+ ")
    Fmt.print("Files less than 10 ^ $-2d bytes : $,5d", i, sizes[i])
}
System.print("                                  -----")
Fmt.print("= Number of files               : $,5d", numFiles)
Fmt.print("  Total size in bytes           : $,d", totalSize)
Fmt.print("  Number of sub-directories     : $,5d", numDirs)
