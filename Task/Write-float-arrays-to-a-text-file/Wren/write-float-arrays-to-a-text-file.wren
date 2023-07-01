import "io" for File
import "/fmt" for Fmt

var x = [1, 2, 3, 1e11]
var y = [1, 1.4142135623730951, 1.7320508075688772, 316227.76601683791]
var xprec = 3 - 1
var yprec = 5 - 1
File.create("filename.txt") { |file|
    for (i in 0...x.count) {
        var f = (i < x.count-1) ? "h" : "e"
        var s  = Fmt.swrite("$0.%(xprec)%(f)\t$0.%(yprec)%(f)\n", x[i], y[i])
        file.writeBytes(s)
    }
}
