import "std/thread.zc"
import "std/io.zc"

fn main() {
    print "Enter number of milliseconds to sleep: ";
    autofree let input = readln();
    let ms = atoi(input);
    println "Sleeping...";
    sleep_ms(ms);
    println "Awake!";
}
