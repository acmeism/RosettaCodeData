import "io" for Stdin,Stdout
import "./str" for Char

var fwrite = Fn.new { |ch|
    System.write(ch)
    Stdout.flush()
}

var doChar // recursive
doChar = Fn.new { |odd, f|
    var c = Stdin.readByte()
    if (!c) return false // end of stream reached
    var ch = String.fromByte(c)

    var writeOut = Fn.new {
        fwrite.call(ch)
        if (f) f.call()
    }

    if (!odd) fwrite.call(ch)
    if (Char.isLetter(ch)) return doChar.call(odd, writeOut)
    if (odd) {
        if (f) f.call()
        fwrite.call(ch)
    }
    return ch != "."
}

for (i in 0..1) {
    var b = true
    while (doChar.call(!b, null)) b = !b
    Stdin.readByte() // remove \n from buffer
    System.print("\n")
}
