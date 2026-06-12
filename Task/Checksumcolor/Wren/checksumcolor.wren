import "./dynamic" for Tuple
import "./fmt" for Conv, Fmt
import "./ioutil" for FileUtil, Stdout
import "./pattern" for Pattern

var Color = Tuple.create("Color", ["r", "g", "b"])

var ColorEx = Tuple.create("ColorEx", ["color", "code"])

var colors = [
    ColorEx.new(Color.new(15,  0,  0), "31"),
    ColorEx.new(Color.new( 0, 15,  0), "32"),
    ColorEx.new(Color.new(15, 15,  0), "33"),
    ColorEx.new(Color.new( 0,  0, 15), "34"),
    ColorEx.new(Color.new(15,  0, 15), "35"),
    ColorEx.new(Color.new( 0, 15, 15), "36")
]

var squareDist = Fn.new { |c1, c2|
    var xd = c2.r - c1.r
    var yd = c2.g - c1.g
    var zd = c2.b - c1.b
    return xd*xd + yd*yd + zd*zd
}

var printColor = Fn.new { |s|
    var n = s.count
    var k = 0
    for (i in 0...(n/3).floor){
        var j = i * 3
        var c1 = s[j]
        var c2 = s[j+1]
        var c3 = s[j+2]
        k = j + 3
        var r = Conv.atoi(c1, 16)
        var g = Conv.atoi(c2, 16)
        var b = Conv.atoi(c3, 16)
        var rgb = Color.new(r, g, b)
        var m = 676
        var colorCode = ""
        for (cex in colors) {
            var sqd = squareDist.call(cex.color, rgb)
            if (sqd < m) {
                colorCode = cex.code
                m = sqd
            }
        }
        Fmt.write("\e[$s;1m$s$s$s\e[00m", colorCode, c1, c2, c3)
    }
    var j = k
    while (j < n) {
        var c = s[j]
        Fmt.write("\e[0;1m$s\e[00m", c)
        j = j + 1
    }
    Stdout.flush()
}

var i = " \t"
var p = Pattern.new("[+1/w][+1/i+1/z]", Pattern.whole, i)

var colorChecksum = Fn.new { |fileName|
    for (line in FileUtil.readLines(fileName)) {
        if (!line) return
        if (p.isMatch(line)) {
            var m  = p.findAll(line)[0]
            var s1 = m.capsText[0]
            var s2 = m.capsText[1]
            printColor.call(s1)
            System.print(s2)
        } else {
            System.print(line)
        }
    }
}

colorChecksum.call("md5sums.txt")
