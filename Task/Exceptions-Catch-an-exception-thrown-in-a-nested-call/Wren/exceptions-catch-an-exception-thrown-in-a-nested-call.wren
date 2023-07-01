var U0 = "U0"
var U1 = "U1"

var bazCalled = 0

var baz = Fn.new {
    bazCalled = bazCalled + 1
    Fiber.abort( (bazCalled == 1) ? U0 : U1 )
}

var bar = Fn.new {
    baz.call()
}

var foo = Fn.new {
    for (i in 1..2) {
        var f = Fiber.new { bar.call() }
        f.try()
        var err = f.error
        if (err == U0) {
            System.print("Caught exception %(err)")
        } else if (err == U1) {
            Fiber.abort("Uncaught exception %(err) rethrown") // re-throw
        }
    }
}

foo.call()
