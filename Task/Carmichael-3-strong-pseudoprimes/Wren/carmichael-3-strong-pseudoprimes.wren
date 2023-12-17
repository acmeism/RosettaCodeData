import "./fmt" for Fmt
import "./math" for Int

var mod = Fn.new { |n, m| ((n%m) + m) % m }

var carmichael = Fn.new { |p1|
    for (h3 in 2...p1) {
        for (d in 1...h3 + p1) {
            if ((h3 + p1) * (p1 - 1) % d == 0 && mod.call(-p1 * p1, h3) == d % h3) {
                var p2 = 1 + ((p1 - 1) * (h3 + p1) / d).floor
                if (Int.isPrime(p2)) {
                    var p3 = 1 + (p1 * p2 / h3).floor
                    if (Int.isPrime(p3)) {
                        if (p2 * p3 % (p1 - 1) == 1) {
                            var c = p1 * p2 * p3
                            Fmt.print("$2d   $4d   $5d  $10d", p1, p2, p3, c)
                        }
                    }
                }
            }
        }
    }
}

System.print("The following are Carmichael munbers for p1 <= 61:\n")
System.print("p1     p2      p3     product")
System.print("==     ==      ==     =======")
for (p1 in 2..61) {
    if (Int.isPrime(p1)) carmichael.call(p1)
}
