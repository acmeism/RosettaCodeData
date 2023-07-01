var compose = Fn.new { |f, g| Fn.new { |x| f.call(g.call(x)) } }

var A = [
    Fn.new { |x| x.sin },
    Fn.new { |x| x.cos },
    Fn.new { |x| x * x * x }
]

var B = [
    Fn.new { |x| x.asin },
    Fn.new { |x| x.acos },
    Fn.new { |x| x.pow(1/3) }
]

var x = 0.5
for (i in 0..2) {
    System.print(compose.call(A[i], B[i]).call(x))
}
