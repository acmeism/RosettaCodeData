import "io" for File

File.delete("input.txt")

// check it worked
System.print(File.exists("input.txt"))
