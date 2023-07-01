var halve = Fn.new { |n| (n/2).truncate }

var double = Fn.new { |n| n * 2 }

var isEven = Fn.new { |n| n%2 == 0 }

var ethiopian = Fn.new { |x, y|
    var sum = 0
    while (x >= 1) {
        if (!isEven.call(x)) sum = sum + y
        x = halve.call(x)
        y = double.call(y)
    }
    return sum
}

System.print("17 x 34 = %(ethiopian.call(17, 34))")
System.print("99 x 99 = %(ethiopian.call(99, 99))")
