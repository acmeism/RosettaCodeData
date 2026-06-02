fn main() {
    let problem: bool[2] = [false, true];
    for p in problem {
        if !p {
            println "There isn't a problem.";
        } else {
            println "There is now, exiting with code 1.";
            exit(1);
        }
    }
}
