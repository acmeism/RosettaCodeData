import "os" for Process
import "io" for File

var args = Process.allArguments
System.write(File.read(args[1]))
