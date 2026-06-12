import "io" for File
import "./dynamic" for Tuple
import "./seq" for Lst

var UserInput = Tuple.create("UserINput", ["formFeed", "lineFeed", "tab", "space"])

var getUserInput = Fn.new {
    var h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " +
            "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"
    return Lst.chunks(h.split(" "), 4).map { |chunk|
        var flts = chunk.map { |c| Num.fromString(c) }.toList
        return UserInput.new(flts[0], flts[1], flts[2], flts[3])
    }
}

var decode = Fn.new { |fileName, uiList|
    var text = File.read(fileName)

    var decode2 = Fn.new { |ui|
        var f = 0
        var l = 0
        var t = 0
        var s = 0
        for (c in text) {
            if (f == ui.formFeed && l == ui.lineFeed && t == ui.tab && s == ui.space) {
                if (c == "!") return false
                System.write(c)
                return true
            }
            if (c == "\f") {
                f = f + 1
                l = 0
                t = 0
                s = 0
            } else if (c == "\n") {
                l = l + 1
                t = 0
                s = 0
            } else if (c == "\t") {
                t = t + 1
                s = 0
            } else {
                s = s + 1
            }
        }
        return false
    }

    for (ui in uiList) if (!decode2.call(ui)) break
    System.print()
}

var uiList = getUserInput.call()
decode.call("theRaven.txt", uiList)
