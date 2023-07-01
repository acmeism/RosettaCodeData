class Church {
    static zero { Fn.new { Fn.new { |x| x } } }

    static succ(c) { Fn.new { |f| Fn.new { |x| f.call(c.call(f).call(x)) } } }

    static add(c, d) { Fn.new { |f| Fn.new { |x| c.call(f).call(d.call(f).call(x)) } } }

    static mul(c, d) { Fn.new { |f| c.call(d.call(f)) } }

    static pow(c, e) { e.call(c) }

    static fromInt(n) {
        var ret = zero
        if (n > 0) for (i in 1..n) ret = succ(ret)
        return ret
    }

    static toInt(c) { c.call(Fn.new { |x| x + 1 }).call(0) }
}

var three = Church.succ(Church.succ(Church.succ(Church.zero)))
var four = Church.succ(three)

System.print("three         -> %(Church.toInt(three))")
System.print("four          -> %(Church.toInt(four))")
System.print("three + four  -> %(Church.toInt(Church.add(three, four)))")
System.print("three * four  -> %(Church.toInt(Church.mul(three, four)))")
System.print("three ^ four  -> %(Church.toInt(Church.pow(three, four)))")
System.print("four  ^ three -> %(Church.toInt(Church.pow(four, three)))")
