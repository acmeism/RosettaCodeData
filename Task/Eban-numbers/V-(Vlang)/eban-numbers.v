struct Range {
    start i64
    end i64
    print bool
}

fn main() {
    rgs := [
        Range{2, 1000, true},
        Range{1000, 4000, true},
        Range{2, 10000, false},
        Range{2, 100000, false},
        Range{2, 1000000, false},
        Range{2, 10000000, false},
        Range{2, 100000000, false},
        Range{2, 1000000000, false}
    ]
    for rg in rgs {
        if rg.start == 2 {
            println("eban numbers up to and including $rg.end:")
        } else {
            println("eban numbers between $rg.start and $rg.end (inclusive):")
        }
        mut count := 0
        for i := rg.start; i <= rg.end; i += 2 {
            b := i / 1000000000
            mut r := i % 1000000000
            mut m := r / 1000000
            r = i % 1000000
            mut t := r / 1000
            r %= 1000
            if m >= 30 && m <= 66 {
                m %= 10
            }
            if t >= 30 && t <= 66 {
                t %= 10
            }
            if r >= 30 && r <= 66 {
                r %= 10
            }
            if b == 0 || b == 2 || b == 4 || b == 6 {
                if m == 0 || m == 2 || m == 4 || m == 6 {
                    if t == 0 || t == 2 || t == 4 || t == 6 {
                        if r == 0 || r == 2 || r == 4 || r == 6 {
                            if rg.print {
                                print("$i ")
                            }
                            count++
                        }
                    }
                }
            }
        }
        if rg.print {
            println('')
        }
        println("count = $count\n")
    }
}
