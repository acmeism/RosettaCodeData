import "/pattern" for Pattern

var p = Pattern.new("/u") // match any upper case letter

var encode = Fn.new { |s|
    if (s == "") return s
    var e = ""
    var curr = s[0]
    var count = 1
    var i = 1
    while (i < s.count) {
        if (s[i] == curr) {
            count = count + 1
        } else {
            e = e + count.toString + curr
            curr = s[i]
            count = 1
        }
        i = i + 1
    }
    return e + count.toString + curr
}

var decode = Fn.new { |e|
    if (e == "") return e
    var letters = Pattern.matchesText(p.findAll(e))
    var numbers = p.splitAll(e)[0..-2].map { |s| Num.fromString(s) }.toList
    return (0...letters.count).reduce("") { |acc, i| acc + letters[i]*numbers[i] }.join()
}

var strings = [
   "AA",
   "RROSETTAA",
   "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
]

for (s in strings) {
    System.print("Original text      : %(s)")
    var e = encode.call(s)
    System.print("Encoded text       : %(e)")
    var d = decode.call(e)
    System.print("Decoded text       : %(d)")
    System.print("Original = decoded : %(s == d)\n")
}
