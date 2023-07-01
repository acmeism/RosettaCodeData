var checkDivByZero = Fn.new { |a, b|
    var c = a / b
    if (c.isInfinity || c.isNan) return true
    return false
}

System.print("Division by zero?")
System.print("  0 / 0 -> %(checkDivByZero.call(0, 0))")
System.print("  1 / 0 -> %(checkDivByZero.call(1, 0))")
System.print("  1 / 1 -> %(checkDivByZero.call(1, 1))")
