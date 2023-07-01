var castOut = Fn.new { |base, start, end|
    var b = base - 1
    var ran = (0...b).where { |n| n % b == (n * n) % b }
    var x = (start/b).floor
    var result = []
    while (true) {
        for (n in ran) {
            var k = b*x + n
            if (k >= start) {
                if (k > end) return result
                result.add(k)
            }
        }
        x = x + 1
    }
}

System.print(castOut.call(16, 1, 255))
System.print()
System.print(castOut.call(10, 1, 99))
System.print()
System.print(castOut.call(17, 1, 288))
