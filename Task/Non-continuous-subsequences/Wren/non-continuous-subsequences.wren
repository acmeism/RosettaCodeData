import "./fmt" for Fmt

var ncs = Fn.new { |a|
    var f = "$d "
    if (a[0] is String) {
        for (i in 0...a.count) a[i] = a[i].bytes[0]
        f = "$c "
    }
    var generate // recursive
    generate = Fn.new { |m, k, c|
        if (k == m) {
            if (c[m - 1] != c[0] + m - 1) {
                for (i in 0...m) Fmt.write(f, a[c[i]])
                System.print()
            }
        } else {
            for (j in 0...a.count) {
                if (k == 0 || j > c[k - 1]) {
                    c[k] = j
                    generate.call(m, k + 1, c)
                }
            }
        }
    }

    for (m in 2...a.count) {
        var c = List.filled(m, 0)
        generate.call(m, 0, c)
    }
}

var a = [1, 2, 3, 4]
ncs.call(a)
System.print()
var ca = ["a", "b", "c", "d", "e"]
ncs.call(ca)
