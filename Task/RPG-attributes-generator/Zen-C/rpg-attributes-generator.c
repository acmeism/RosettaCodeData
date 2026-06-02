import "std/random.zc"
import "std/sort.zc"

fn main() {
    let rng = Random::new();
    let vals: [int; 6];
    loop {
        for i in 0..6 {
            let rns: [int; 4];
            for j in 0..4 { rns[j] = rng.next_int_range(1, 6); }
            let sum = 0;
            for v in rns { sum += v; }
            sort_int((int*)rns, 4);
            vals[i] = sum - rns[0];
        }
        let total = 0;
        for v in vals { total += v; }
        if total > 75 {
            let fifteens = 0;
            for v in vals {
                if v >= 15 { fifteens++; }
            }
            if fifteens >= 2 {
                print "The six values are: ";
                for v in vals { print "{v}, "; }
                println "\b\b ";
                println "Their total is: {total} and {fifteens} of them are >= 15.";
                break;
            }
        }
    }
}
