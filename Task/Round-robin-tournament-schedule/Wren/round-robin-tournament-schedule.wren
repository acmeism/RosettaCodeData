import "./fmt" for Fmt

var rotate = Fn.new { |lst|
    var last = lst[-1]
    for (i in lst.count-1..1) lst[i] = lst[i-1]
    lst[0] = last
}

var roundRobin = Fn.new { |n|
    var lst = (2..n).toList
    if (n % 2 == 1) {
        lst.add(0) // 0 denotes a bye
        n = n + 1
    }
    for (r in 1...n) {
        Fmt.write("Round $2d", r)
        var lst2 = [1] + lst
        for (i in 0...n/2) Fmt.write(" ($2d vs $-2d)", lst2[i], lst2[n - 1 - i])
        System.print()
        rotate.call(lst)
    }
}

System.print("Round robin for 12 players:\n")
roundRobin.call(12)
System.print("\n\nRound robin for 5 players (0 denotes a bye) :\n")
roundRobin.call(5)
