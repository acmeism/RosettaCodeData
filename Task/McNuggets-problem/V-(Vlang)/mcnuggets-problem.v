fn mcnugget(limit int) {
    mut sv := []bool{len: limit+1} // all false by default
    for s := 0; s <= limit; s += 6 {
        for n := s; n <= limit; n += 9 {
            for t := n; t <= limit; t += 20 {
                sv[t] = true
            }
        }
    }
    for i := limit; i >= 0; i-- {
        if !sv[i] {
            println("Maximum non-McNuggets number is $i")
            return
        }
    }
}

fn main() {
   mcnugget(100)
}
