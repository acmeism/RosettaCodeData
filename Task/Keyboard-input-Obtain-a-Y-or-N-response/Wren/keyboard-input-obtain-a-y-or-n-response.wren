import "io" for Stdin, Stdout

Stdin.isRaw = true // input is neither echoed nor buffered in this mode

System.print("Press Y or N")
Stdout.flush()

var byte
while ((byte = Stdin.readByte()) && !"YNyn".bytes.contains(byte)) {}
var yn = String.fromByte(byte)
System.print(yn)

Stdin.isRaw = false
