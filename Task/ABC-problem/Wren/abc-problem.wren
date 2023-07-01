import "/fmt" for Fmt

var r // recursive
r = Fn.new { |word, bl|
    if (word == "") return true
    var c = word.bytes[0] | 32
    for (i in 0...bl.count) {
        var b = bl[i]
        if (c == b.bytes[0] | 32 || c == b.bytes[1] | 32) {
            bl[i] = bl[0]
            bl[0] = b
            if (r.call(word[1..-1], bl[1..-1])) return true
            var t = bl[i]
            bl[i] = bl[0]
            bl[0] = t
        }
    }
    return false
}

var newSpeller = Fn.new { |blocks|
    var bl = blocks.split(" ")
    return Fn.new { |word| r.call(word, bl) }
}

var sp = newSpeller.call("BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM")
for (word in ["A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"]) {
    System.print("%(Fmt.s(-7, word)) %(sp.call(word))")
}
