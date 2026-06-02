import "unistd.h"

fn main() {
    let res = isatty(fileno(stdin)) ? "true" : "false";
    println "Input device is a terminal? {res}";
}
