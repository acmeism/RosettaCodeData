import "locale.h";

fn sieve(sv: bool*) {
    let ds: [int; 10000];
    let i = 9999;
    for a in 9..=0 step -1 {
        for b in 9..=0 step -1 {
            let s = a + b;
            for c in 9..=0 step -1 {
                let t = s + c;
                for d in 9..=0 step -1 {
                    ds[i--] = t + d;
                }
            }
        }
    }
    let n = 0;
    for a in 0..103 {
        let d = ds[a];
        for b in  0..1000 {
            let s = d + ds[b] + n;
            for c in 0..10000 {
                sv[ds[c] + (s++)] = true;
            }
            n += 10000;
        }
    }
}

fn main() {
    def MC = 103 * 1000 * 10000 + 11 * 9 + 1;
    autofree let sv = (bool*)calloc(MC + 1, sizeof(bool));
    sieve(sv);
    let count = 0;
    println "The first 50 self numbers are:";
    for let i = 0; count <= 50; ++i {
        if !sv[i] {
            if ++count <= 50 {
                print "{i:3d}  ";
                if !(count % 10) { println ""; }
            } else {
                setlocale(LC_NUMERIC, "");
                println "\n       Index     Self number";
            }
        }
    }
    let limit = 1;
    count = 0;
    for let i = 0; i < MC; ++i {
        if !sv[i] {
            if ++count == limit {
                println "{count:'12d}  {i:'13d}";
                limit *= 10;
            }
        }
    }
}
