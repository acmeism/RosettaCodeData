import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var maxDigits = 8
var limit = 10.pow(maxDigits)
var c = Int.primeSieve(limit-1, false)

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

var isPerfectPower = Fn.new { |n|
    if (n == 1) return true
    var x = 2
    while (x * x <= n) {
        var y = 2
        var p = x.pow(y)
        while (p > 0 && p <= n) {
            if (p == n) return true
            y = y + 1
            p = x.pow(y)
        }
        x = x + 1
    }
    return false
}

var isPowerful = Fn.new { |n|
    while (n % 2 == 0) {
        var p = 0
        while (n % 2 == 0) {
            n = (n/2).floor
            p = p + 1
        }
        if (p == 1) return false
    }
    var f = 3
    while (f * f <= n) {
        var p = 0
        while (n % f == 0) {
            n = (n/f).floor
            p = p + 1
        }
        if (p == 1) return false
        f = f + 2
    }
    return n == 1
}

var isAchilles = Fn.new { |n| c[n] && isPowerful.call(n) && !isPerfectPower.call(n) }

var isStrongAchilles = Fn.new { |n|
    if (!isAchilles.call(n)) return false
    var tot = totient.call(n)
    return isAchilles.call(tot)
}

System.print("First 50 Achilles numbers:")
var achilles = []
var count = 0
var n = 2
while (count < 50) {
    if (isAchilles.call(n)) {
        achilles.add(n)
        count = count + 1
    }
    n = n + 1
}
for (chunk in Lst.chunks(achilles, 10)) Fmt.print("$4d", chunk)

System.print("\nFirst 30 strong Achilles numbers:")
var strongAchilles = []
count = 0
n = achilles[0]
while (count < 30) {
    if (isStrongAchilles.call(n)) {
        strongAchilles.add(n)
        count = count + 1
    }
    n = n + 1
}
for (chunk in Lst.chunks(strongAchilles, 10)) Fmt.print("$5d", chunk)

System.print("\nNumber of Achilles numbers with:")
var pow = 10
for (i in 2..maxDigits) {
    var count = 0
    for (j in pow..pow*10-1) {
        if (isAchilles.call(j)) count = count + 1
    }
    System.print("%(i) digits: %(count)")
    pow = pow * 10
}
