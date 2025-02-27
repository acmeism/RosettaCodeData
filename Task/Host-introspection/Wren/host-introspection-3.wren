import "os" for Process

var wordSize   = Process.read("getconf LONG_BIT")
var endianness = Process.read("lscpu | grep \"Byte Order\"").split(":")[1].trimStart()
System.print("word size  = %(wordSize) bits")
System.print("endianness = %(endianness)")
