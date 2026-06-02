import "unistd.h"

fn main() {
    let res = isatty(fileno(stdout)) ? "true" : "false";
    println "Output device is a terminal? {res}";
}
