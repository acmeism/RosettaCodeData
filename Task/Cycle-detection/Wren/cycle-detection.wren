var brent = Fn.new { |f, x0|
    var lam = 1
    var power = 1
    var tortoise = x0
    var hare = f.call(x0)
    while (tortoise != hare) {
        if (power == lam) {
            tortoise = hare
            power = power * 2
            lam = 0
        }
        hare = f.call(hare)
        lam = lam + 1
    }
    tortoise = hare = x0
    for (i in 0...lam) hare = f.call(hare)
    var mu = 0
    while (tortoise != hare) {
        tortoise = f.call(tortoise)
        hare = f.call(hare)
        mu = mu + 1
    }
    return [lam, mu]
}

var f = Fn.new { |x| (x*x + 1) % 255 }
var x0 = 3
var x = x0
var seq = List.filled(21, 0) // limit to first 21 terms say
for (i in 0..20) {
    seq[i] = x
    x = f.call(x)
}
var res = brent.call(f, x0)
var lam = res[0]
var mu = res[1]
System.print("Sequence     = %(seq)")
System.print("Cycle length = %(lam)")
System.print("Start index  = %(mu)")
System.print("Cycle        = %(seq[mu...mu+lam])")
