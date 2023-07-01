var func2 = Fn.new {
    Fiber.abort("Forced error.")
}

var func1 = Fn.new {
    func2.call()
}

func1.call()
