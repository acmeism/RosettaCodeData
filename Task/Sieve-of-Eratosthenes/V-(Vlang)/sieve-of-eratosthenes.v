fn main() {
    limit := 201 // means sieve numbers < 201

    // sieve
    mut c := []bool{len: limit} // c for composite.  false means prime candidate
    c[1] = true              // 1 not considered prime
    mut p := 2
    for {
        // first allowed optimization:  outer loop only goes to sqrt(limit)
        p2 := p * p
        if p2 >= limit {
            break
        }
        // second allowed optimization:  inner loop starts at sqr(p)
        for i := p2; i < limit; i += p {
            c[i] = true // it's a composite
        }
        // scan to get next prime for outer loop
        for {
            p++
            if !c[p] {
                break
            }
        }
    }

    // sieve complete.  now print a representation.
    for n in 1..limit {
        if c[n] {
            print("  .")
        } else {
            print("${n:3}")
        }
        if n%20 == 0 {
            println("")
        }
    }
}
