#!/bin/wren Multiline_shebang_2.wren
import "os" for Process

var args = Process.allArguments
System.print("Executable    : %(args[0])")
System.print("Script name   : %(args[1])")
System.print("Shell command : %(args[2])")
if (args.count > 3) {
    for (i in 3...args.count) System.print("Argument %(i-2)    : %(args[i])")
}
