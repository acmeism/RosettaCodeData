import "io" for Directory

var path = "./" // or whatever

// Note that output is automatically sorted using this method.
Directory.list(path).each { |f| System.print(f) }
