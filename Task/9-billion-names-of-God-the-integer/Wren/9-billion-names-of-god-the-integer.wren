import "/big" for BigInt
import "/fmt" for Fmt

var cache = [[BigInt.one]]
var cumu = Fn.new { |n|
    if (cache.count <= n) {
        (cache.count..n).each { |l|
            var r = [BigInt.zero]
            (1..l).each { |x|
                var min = l - x
                if (x < min) min = x
                r.add(r[-1] + cache[l - x][min])
            }
            cache.add(r)
        }
    }
    return cache[n]
}

var row = Fn.new { |n|
    var r = cumu.call(n)
    return (0...n).map { |i| r[i+1] - r[i] }.toList
}

System.print("Rows:")
(1..25).each { |i|
    Fmt.print("$2d: $s", i, row.call(i))
}

System.print("\nSums:")
[23, 123, 1234, 12345].each { |i|
    Fmt.print("$5s: $s", i, cumu.call(i)[-1])
}
