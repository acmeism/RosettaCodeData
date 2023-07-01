var egyptianDivide = Fn.new { |dividend, divisor|
    if (dividend < 0 || divisor <= 0) Fiber.abort("Invalid argument(s).")
    if (dividend < divisor) return [0, dividend]
    var powersOfTwo = [1]
    var doublings = [divisor]
    var doubling = divisor
    while (true) {
        doubling = 2 * doubling
        if (doubling > dividend) break
        powersOfTwo.add(powersOfTwo[-1]*2)
        doublings.add(doubling)
    }
    var answer = 0
    var accumulator = 0
    for (i in doublings.count-1..0) {
        if (accumulator + doublings[i] <= dividend) {
            accumulator = accumulator + doublings[i]
            answer = answer + powersOfTwo[i]
            if (accumulator == dividend) break
        }
    }
    return [answer, dividend - accumulator]
}

var dividend = 580
var divisor = 34
var res = egyptianDivide.call(dividend, divisor)
System.print("%(dividend) ÷ %(divisor) = %(res[0]) with remainder %(res[1]).")
