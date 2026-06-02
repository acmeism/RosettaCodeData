import "std/vec.zc"
import "std/set.zc"

fn main() {
    let a = Vec<int>::new();
    a << 0;
    let used = Set<int>::new();
    used.add(0);
    let used1000 = Set<int>::new();
    used1000.add(0);
    let found_dup = false;
    let n = 1;
    while n <= 15 || !found_dup || used1000.length() < 1001 {
        let next = a[n - 1] - n;
        if next < 1 || used.contains(next) { next += 2 * n; }
        let already_used = used.contains(next);
        a << next;
        if !already_used {
            used.add(next);
            if next >= 0 && next <= 1000 { used1000.add(next); }
        }
        if n == 14 {
            println "The first 15 terms of the Recaman's sequence are:";
            print "[";
            for v in a { print "{v}, "; }
            println "\b\b]";
        }
        if !found_dup && already_used {
            println "\nThe first duplicated term is a[{n}] = {next}.";
            found_dup = true;
        }
        if used1000.length() == 1001 {
            println "\nTerms up to a[{n}] are needed to generate 0 to 1000.";
        }
        n++;
    }
}
