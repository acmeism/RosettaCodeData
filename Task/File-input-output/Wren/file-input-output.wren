import "io" for File

var contents = File.read("input.txt")
File.create("output.txt") {|file|
    file.writeBytes(contents)
}
