import "io" for Stdin, Stdout
import "/fmt" for Fmt

var getNum = Fn.new { |prompt|
    while (true) {
        System.write(prompt)
        Stdout.flush()
        var input = Stdin.readLine()
        var n = Num.fromString(input)
        if (n) return n
        System.print("Invalid number, try again.")
    }
}

var lat = getNum.call("Enter latitude       : ")
var lng = getNum.call("Enter longitude      : ")
var ref = getNum.call("Enter legal meridian : ")
var slat = (lat * Num.pi / 180).sin
var diff = lng - ref
System.print("\n    sine of latitude : %(slat)")
System.print("    diff longitude   : %(diff)")
System.print("\nHour, sun hour angle, dial hour line angle from 6am to 6pm")
for (h in -6..6) {
    var hra = 15*h - diff
    var s = (hra * Num.pi /180).sin
    var c = (hra * Num.pi /180).cos
    var hla = (slat*s).atan(c) * 180 / Num.pi
    Fmt.print("$2.0f $8.3f $8.3f", h, hra, hla)
}
