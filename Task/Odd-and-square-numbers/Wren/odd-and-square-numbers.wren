import "./iterate" for Stepped
import "./seq" for Lst

var pow = 1
for (p in 0..4) {
    var low = pow.sqrt.ceil
    if (low % 2 == 0) low = low + 1
    pow = pow * 10
    var high = pow.sqrt.floor
    var oddSq = Stepped.new(low..high, 2).map { |i| i * i }.toList
    System.print("%(oddSq.count) odd squares from %(pow/10) to %(pow):")
    for (chunk in Lst.chunks(oddSq, 10)) System.print(chunk.join(" "))
    System.print()
}
