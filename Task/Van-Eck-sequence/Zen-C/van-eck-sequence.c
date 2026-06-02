import "std/map.zc"

fn main() {
    def MAX = 1000;
    let a:[int; MAX];
    let seen = Map<int>::new();
    for n in 0..(MAX - 1) {
        let sn = "{a[n]}";
        if seen.contains(sn) {
            a[n + 1] = n - seen[sn].unwrap();
        }
        seen.put(sn, n);
    }
    println "The first ten terms of the Van Eck sequence are:";
    for i in 0..10 { print "{a[i]}, "; }
    println "\b\b \n";
    println "Terms 991 to 1000 of the sequence are:";
    for i in 990..1000 { print "{a[i]}, "; }
    println "\b\b \n";
}
