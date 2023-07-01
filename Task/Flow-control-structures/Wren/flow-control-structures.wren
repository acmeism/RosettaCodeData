var func = Fn.new { |n|
    var i = 1
    while (true) {
        if (i == 1) {
            i = i + 1
            continue // jumps to next iteration
        }
        System.print(i)
        if (i == n) break // exits while loop
        i = i + 1
    }
    if (n < 3) return // exits function
    System.print(n + 1)
}

var fiber = Fiber.new {
    Fiber.abort("Demo error") // error occurred, abort script
}

var a = [2, 3]
for (n in a) {
    func.call(n)
    if (n > 2) return // end module and hence the script as it's a single module script
    var error = fiber.try() // catch any error
    System.print("Caught error: " + error)
}
