import "./set" for Set
import "./seq" for Lst
import "./fmt" for Fmt

var totient = Fn.new { |n|
    var tot = n
    var i = 2
    while (i*i <= n) {
        if (n%i == 0) {
            while(n%i == 0) n = (n/i).floor
            tot = tot - (tot/i).floor
        }
        if (i == 2) i = 1
        i = i + 2
    }
    if (n > 1) tot = tot - (tot/n).floor
    return tot
}

var pps = Set.new()

var getPerfectPowers = Fn.new { |maxExp|
    var upper = 10.pow(maxExp)
    for (i in 2..upper.sqrt.floor) {
        var p = i
        while ((p = p * i) < upper) pps.add(p)
    }
}

var getAchilles = Fn.new { |minExp, maxExp|
    var lower = 10.pow(minExp)
    var upper = 10.pow(maxExp)
    var achilles = Set.new() // avoids duplicates
    for (b in 1..upper.cbrt.floor) {
        var b3 = b * b * b
        for (a in 1..upper.sqrt.floor) {
            var p = b3 * a * a
            if (p >= upper) break
            if (p >= lower) {
                if (!pps.contains(p)) achilles.add(p)
            }
        }
    }
    return achilles
}

var maxDigits = 15
getPerfectPowers.call(maxDigits)

var achillesSet = getAchilles.call(1, 5) // enough for first 2 parts
var achilles = achillesSet.toList
achilles.sort()

System.print("First 50 Achilles numbers:")
for (chunk in Lst.chunks(achilles[0..49], 10)) Fmt.print("$4d", chunk)

System.print("\nFirst 30 strong Achilles numbers:")
var strongAchilles = []
var count = 0
var n = 0
while (count < 30) {
    var tot = totient.call(achilles[n])
    if (achillesSet.contains(tot)) {
        strongAchilles.add(achilles[n])
        count = count + 1
    }
    n = n + 1
}
for (chunk in Lst.chunks(strongAchilles, 10)) Fmt.print("$5d", chunk)

System.print("\nNumber of Achilles numbers with:")
for (d in 2..maxDigits) {
    var ac = getAchilles.call(d-1, d).count
    Fmt.print("$2d digits: $d", d, ac)
}
