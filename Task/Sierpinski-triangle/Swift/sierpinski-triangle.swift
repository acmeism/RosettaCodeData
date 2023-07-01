import Foundation

// Easy get/set of charAt
extension String {
    subscript(index:Int) -> String {
        get {
            var array = Array(self)
            var charAtIndex = array[index]
            return String(charAtIndex)
        }

        set(newValue) {
            var asChar = Character(newValue)
            var array = Array(self)
            array[index] = asChar
            self = String(array)
        }
    }
}

func triangle(var n:Int) {
    n = 1 << n
    var line = ""
    var t = ""
    var u = ""

    for (var i = 0; i <= 2 * n; i++) {
        line += " "
    }

    line[n] = "*"

    for (var i = 0; i < n; i++) {
        println(line)
        u = "*"
        for (var j = n - i; j < n + i + 1; j++) {
            t = line[j-1] == line[j + 1] ? " " : "*"
            line[j - 1] = u
            u = t
        }
        line[n + i] = t
        line[n + i + 1] = "*"
    }
}
