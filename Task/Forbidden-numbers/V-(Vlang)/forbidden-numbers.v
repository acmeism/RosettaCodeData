fn forbidden(q int) bool {
    mut n := q
    for (n > 1) && (n&3 == 0) {
        n >>= 2
    }
    return n%8 == 7
}

mut c := 0
mut n := 1
for c < 50 {
    if forbidden(n) {
        println(n)
        c++
    }
    n++
}

for lim in [500,5000,50000,500000] {
    for n <= lim {
        if forbidden(n) {c++}
        n++
    }
    println("Forbidden numbers <= ${lim}: ${c}")
}
