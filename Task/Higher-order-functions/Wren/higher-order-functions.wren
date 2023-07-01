var first = Fn.new { |f|
    System.print("first function called")
    f.call()
}

var second = Fn.new { System.print("second function called") }

first.call(second)
