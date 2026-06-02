import "std/io.zc"

fn main() {
    let n = 0;
    let sum = 0;
    loop {
        print "Enter integral rainfall (99999 to quit): ";
        autofree let input = readln();
        if strchr(input, '.') {
            println "Must be a non-zero integer, try again.";
            continue;
        }
        let i = atoi(input);
        if !i {
            println "Must be a non-zero integer, try again.";
            continue;
        }
        if i == 99999 { break; }
        n++;
        sum += i;
        let avg = (f64)sum / (f64)n;
        println "  The current average rainfall is {avg:g}";
    }
}
