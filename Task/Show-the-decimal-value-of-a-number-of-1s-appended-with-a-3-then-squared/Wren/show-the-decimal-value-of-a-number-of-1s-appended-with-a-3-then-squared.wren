import "./fmt" for Fmt

var a = Fn.new { |n|
    var s = Num.fromString("1" * n + "3")
    var t = s * s
    Fmt.print("$d $d", s, t)
}

for (n in 0..7) a.call(n)
