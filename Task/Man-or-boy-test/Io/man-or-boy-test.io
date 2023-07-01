Range

a := method(k, xs,
    b := block(
        k = k -1
        a(k, list(b, xs slice(0,4)) flatten))
    if(k <= 0,
        (xs at(3) call) + (xs at(4) call),
        b call))

f := method(x, block(x))
1 to(500) foreach(k,
    (k .. " ") print
    a(k, list(1, -1, -1, 1, 0) map (x, f(x))) println)
