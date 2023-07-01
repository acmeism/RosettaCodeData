import "/sort" for Sort, Find
import "/fmt" for Fmt
import "/str" for Str

var permute = Fn.new { |s|
    var res = []
    if (s.count == 0) return res
    var bytes = s.bytes.toList
    var rc // recursive closure
    rc = Fn.new { |np|
        if (np == 1) {
            res.add(bytes.map { |b| String.fromByte(b) }.join())
            return
        }
        var np1 = np - 1
        var pp = bytes.count - np1
        rc.call(np1)
        var i = pp
        while (i > 0) {
            var t = bytes[i]
            bytes[i] = bytes[i-1]
            bytes[i-1] = t
            rc.call(np1)
            i = i - 1
        }
        var w = bytes[0]
        for (i in 1...pp+1) bytes[i-1] = bytes[i]
        bytes[pp] = w
    }
    rc.call(bytes.count)
    return res
}

var algorithm1 = Fn.new { |nums|
    System.print("Algorithm 1")
    System.print("-----------")
    for (num in nums) {
        var perms = permute.call(num)
        var le = perms.count
        if (le > 0) { // ignore blanks
            Sort.quick(perms)
            var ix = Find.all(perms, num)[2].from
            var next = ""
            if (ix < le-1) {
                for (i in ix + 1...le) {
                    if (Str.gt(perms[i], num)) {
                        next = perms[i]
                        break
                    }
                }
            }
            if (next.count > 0) {
                Fmt.print("$,29s -> $,s", num, next)
            } else {
                Fmt.print("$,29s -> 0", num)
            }
        }
    }
    System.print()
}

var algorithm2 = Fn.new { |nums|
    System.print("Algorithm 2")
    System.print("-----------")
    for (num in nums) {
        var bytes = num.bytes.toList
        var le = bytes.count
        var outer = false
        if (le > 0) { // ignore blanks
            var max = num[-1].bytes[0]
            var mi = le - 1
            var i = le - 2
            while (i >= 0) {
                if (bytes[i] < max) {
                    var min = max - bytes[i]
                    var j = mi + 1
                    while (j < le) {
                        var min2 = bytes[j] - bytes[i]
                        if (min2 > 0 && min2 < min) {
                            min = min2
                            mi = j
                        }
                        j = j + 1
                    }
                    var t = bytes[i]
                    bytes[i] = bytes[mi]
                    bytes[mi] = t
                    var c = bytes[i+1..-1]
                    Sort.quick(c)
                    var next = bytes[0...i+1].map { |b| String.fromByte(b) }.join()
                    next = next + c.map { |b| String.fromByte(b) }.join()
                    Fmt.print("$,29s -> $,s", num, next)
                    outer = true
                    break
                } else if (bytes[i] > max) {
                    max = num[i].bytes[0]
                    mi = i
                }
                i = i - 1
            }
        }
        if (!outer) Fmt.print("$29s -> 0", num)
    }
}

var nums = ["0", "9", "12", "21", "12453", "738440", "45072010", "95322020", "9589776899767587796600"]
algorithm1.call(nums[0...-1]) // exclude the last one
algorithm2.call(nums)         // include the last one
