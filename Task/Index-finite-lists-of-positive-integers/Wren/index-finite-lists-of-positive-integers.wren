import "./big" for BigInt

// Separates each integer in the list with an 'a' then encodes in base 11.
// Empty list mapped to '-1'.
var rank = Fn.new { |li|
    if (li.count == 0) return BigInt.minusOne
    return BigInt.fromBaseString(li.join("a"), 11)
}

var unrank = Fn.new { |r|
    if (r == BigInt.minusOne) return []
    return r.toBaseString(11).split("a").map { |d| (d != "") ? Num.fromString(d) : 0 }.toList
}

// Each integer n in the list mapped to '1' plus n '0's.
// Empty list mapped to '0'
var rank2 = Fn.new { |li|
    if (li.isEmpty) return BigInt.zero
    var sb = ""
    for (i in li) sb = sb + "1" + ("0" * i)
    return BigInt.fromBaseString(sb, 2)
}

var unrank2 = Fn.new { |r|
    if (r == BigInt.zero) return []
    return r.toBaseString(2)[1..-1].split("1").map { |d| d.count }.toList
}

var li = [0, 1, 2, 3, 10, 100, 987654321]
System.print("Before ranking  : %(li)")
var r = rank.call(li)
System.print("Rank = %(r)")
li = unrank.call(r)
System.print("After unranking : %(li)")
System.print("\nAlternative approach (not suitable for large numbers)...\n")
li = li[0..-2]
System.print("Before ranking  : %(li)")
r = rank2.call(li)
System.print("Rank = %(r)")
li = unrank2.call(r)
System.print("After unranking : %(li)")
