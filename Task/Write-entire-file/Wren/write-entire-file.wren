import "io" for File

// create a text file
File.create("hello.txt") { |file|
    file.writeBytes("hello")
}

// check it worked
System.print(File.read("hello.txt"))

// overwrite it by 'creating' the file again
File.create("hello.txt") {|file|
    file.writeBytes("goodbye")
}

// check it worked
System.print(File.read("hello.txt"))
