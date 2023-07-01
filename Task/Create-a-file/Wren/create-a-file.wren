import "io" for File

// file is closed automatically after creation
File.create("output.txt") {}

// check size
System.print("%(File.size("output.txt")) bytes")
