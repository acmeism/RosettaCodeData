var fs = Fn.new { |f, s| s.map { |e| f.call(e) }.toList }
var f1 = Fn.new { |n| 2 * n }
var f2 = Fn.new { |n| n * n }

var partial = Fn.new { |f, g| Fn.new { |x| f.call(g, x) } }

var ss = [[0, 1, 2, 3], [2, 4, 6, 8]]
for (s in ss) {
    var fsf1 = partial.call(fs, f1)
    var fsf2 = partial.call(fs, f2)
    System.print(fsf1.call(s))
    System.print(fsf2.call(s))
    System.print()
}
