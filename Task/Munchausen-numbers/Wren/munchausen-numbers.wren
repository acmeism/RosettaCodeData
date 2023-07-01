var powers = List.filled(10, 0)
for (i in 1..9) powers[i] = i.pow(i).round // cache powers

var munchausen = Fn.new {|n|
    if (n <= 0) Fiber.abort("Argument must be a positive integer.")
    var nn = n
    var sum = 0
    while (n > 0) {
        var digit = n % 10
        sum = sum + powers[digit]
        n = (n/10).floor
    }
    return nn == sum
}

System.print(powers)
System.print("The Munchausen numbers <= 5000 are:")
for (i in 1..5000) {
    if (munchausen.call(i)) System.print(i)
}
