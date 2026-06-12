fn main() {
    let prev = 0.0;
    ? "" (prev);
    let count = 0;
    loop {
        let next = (prev + 3) * 0.86;
        if prev == next { break; }
        prev = next;
        print "{prev:9.6f} ";
        if ++count % 10 == 0 { println ""; }
    }
    println "\nTook {count + 1} iterations.";
}
