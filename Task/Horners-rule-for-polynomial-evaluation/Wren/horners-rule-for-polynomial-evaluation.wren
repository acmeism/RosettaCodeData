var horner = Fn.new { |x, c|
    var count = c.count
    if (count == 0) return 0
    return (count-1..0).reduce(0) { |acc, index| acc*x + c[index] }
}

System.print(horner.call(3, [-19, 7, -4, 6]))
