import "os" for Process
import "io" for Directory, File
import "./fmt" for Fmt
import "./ioutil" for FileUtil, Input

var args = Process.arguments
if (args.count > 2) {
    System.print("Too many arguments - maximum is two.")
}
var verbose = false
var path = ""
if (args.count == 0) {
    path = "./"  // current directory
} else if (args.count == 1) {
    if (args[0] == "--v" || args[0] == "--verbose") {
        verbose = true
        path = "./"
    } else {
        path = args[0]
    }
} else if (args[0] == "--v" || args[0] == "--verbose") {
    verbose = true
    path = args[1]
} else {
    System.print("First argument is invalid, must be --v(erbose)")
    return
}
if (!Directory.exists(path)) {
    System.print("Unable to find directory : %(path)")
    return
}

// ignore sub-directories and other special files
if (!path.endsWith("/")) path = path + "/"
var fileNames = Directory.list(path).where { |f| File.exists(path + f) }.toList
if (fileNames.count == 0) {
    System.print("There are no files in directory: %(path)")
    return
} else if (fileNames.count > 999) {
    System.print("There are too many files to process - maximum is 999.")
    return
}
var origNames = []  // keep a list of the original file names and their index numbers
var ix = 1
File.create("vidir.txt") { |f|
    for (fileName in fileNames) {
        var ixs = Fmt.dz(3, ix) // 3 digits, zero filled
        f.writeBytes(Fmt.swrite("$s $s\n", ixs, fileName))
        origNames.add([ixs, fileName])
        ix = ix + 1
    }
}

// create a new file with amended details
File.create("vidir2.txt") { |f2|
    var lines = FileUtil.readLines("vidir.txt")
    for (line in lines) {
        if (line == "") continue  // get rid of any extraneous blank lines
        System.print(line)
        var action = Input.option("  (p)ass, (a)mend, (d)elete ? : ", "padPAD")
        if (action == "p" || action == "P") {
            f2.writeBytes(line + "\n")
            continue
        }
        if (action == "d" || action == "D") {
            continue
        }
        var name = Input.text("  Enter amended file name : ", 1)
        f2.writeBytes(line[0..3] + name + "\n")
    }
}

// change vidir2.txt to vidir.txt overwriting original file
FileUtil.move("vidir2.txt", "vidir.txt", true)

// process by first creating a map of the new names by index number
var newNames = {}
var lines = FileUtil.readLines("vidir.txt")
for (line in lines) {
    if (line == "") continue
    var split = line.split(" ")
    newNames[split[0]] = split[1]
}

// now iterate through the origNames list and pass/amend/delete as appropriate
System.print()
if (verbose) System.print("The following changes are being made:")
for (origName in origNames) {
    var ixs = origName[0]
    var old = origName[1]
    var new = newNames[ixs]
    if (new == null) {  // file to be deleted }
        File.delete(path + old)
        if (verbose) System.print("  Deleting '%(old)'")
    } else if (new != old) { // file name to be changed
        FileUtil.move(path + old, path + new, true)
        if (verbose) System.print("  Changing '%(old)' to '%(new)'")
    }
}
if (verbose) System.print("All changes have now been processed.")
