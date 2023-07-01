import rand
import rand.seed
const target = "METHINKS IT IS LIKE A WEASEL".bytes()
const set = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ".bytes()



fn initialize() []u8 {
    rand.seed(seed.time_seed_array(2))
    mut parent := []u8{len: target.len}
    for i in 0..parent.len {
        parent[i] = set[rand.intn(set.len) or {0}]
    }
    return parent
}

// fitness:  0 is perfect fit.  greater numbers indicate worse fit.
fn fitness(a []u8) int {
    mut h := 0
    // (hamming distance)
    for i, tc in target {
        if a[i] != tc {
            h++
        }
    }
    return h
}

// set m to mutation of p, with each character of p mutated with probability r
fn mutate(p []u8, mut m []u8, r f64) {
    for i, ch in p {
        if rand.f64() < r {
            m[i] = set[rand.intn(set.len) or {0}]
        } else {
            m[i] = ch
        }
    }
}

fn main() {
    c := 20 // number of times to copy and mutate parent

    mut parent := initialize()
    mut copies := [][]u8{len: c, init: []u8{len: parent.len}}

    println(parent.bytestr())
    for best := fitness(parent); best > 0; {
        for mut cp in copies {
            mutate(parent, mut cp, .05)
        }
        for cp in copies {
            fm := fitness(cp)
            if fm < best {
                best = fm
                parent = cp.clone()
                println(parent.bytestr())
            }
        }
    }
}
