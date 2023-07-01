fn gcd(aa int, bb int) int {
    mut a,mut b:=aa,bb
    for a != b {
        if a > b {
            a -= b
        } else {
            b -= a
        }
    }
    return a
}

fn are_same(ss []int, tt []int) bool {
    mut s,mut t:=ss.clone(),tt.clone()
    le := s.len
    if le != t.len {
        return false
    }
    s.sort()
    t.sort()
    for i in 0..le {
        if s[i] != t[i] {
            return false
        }
    }
    return true
}
const limit = 100
fn main() {
    starts := [2, 5, 7, 9, 10]
    mut ekg := [5][limit]int{}

    for s, start in starts {
        ekg[s][0] = 1
        ekg[s][1] = start
        for n in 2..limit {
            for i := 2; ; i++ {
                // a potential sequence member cannot already have been used
                // and must have a factor in common with previous member
                if !ekg[s][..n].contains(i) && gcd(ekg[s][n-1], i) > 1 {
                    ekg[s][n] = i
                    break
                }
            }
        }
        println("EKG(${start:2}): ${ekg[s][..30]}")
    }

    // now compare EKG5 and EKG7 for convergence
    for i in 2..limit {
        if ekg[1][i] == ekg[2][i] && are_same(ekg[1][..i], ekg[2][..i]) {
            println("\nEKG(5) and EKG(7) converge at term ${i+1}")
            return
        }
    }
    println("\nEKG5(5) and EKG(7) do not converge within $limit terms")
}
