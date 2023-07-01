import "os" for Process, Platform
import "io" for File, Stdin, Stdout

var args = Process.allArguments
var text = File.read(args[1]).trim()
System.print("Enter the number of lines to be input followed by those lines:\n")
Stdout.flush()
var n = Num.fromString(Stdin.readLine())
var lines = List.filled(n, null)
for (i in 0...n) lines[i] = Stdin.readLine()
var joiner = Platform.isWindows ? "\r\n" : "\n"
var text2 = lines.join(joiner)
System.print()
if (text2 == text) {
    System.print("accept")
} else if (text.startsWith(text2)) {
    System.print("not yet finished")
} else {
    System.print("reject")
}
