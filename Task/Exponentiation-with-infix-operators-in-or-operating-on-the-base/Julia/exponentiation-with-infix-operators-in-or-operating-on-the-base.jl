for x in [-5, 5], p in [2, 3]
    println("x is", lpad(x, 3), ", p is $p, -x^p is", lpad(-x^p, 4), ", -(x)^p is",
        lpad(-(x)^p, 5), ", (-x)^p is", lpad((-x)^p, 5), ", -(x^p) is", lpad(-(x^p), 5))
end
