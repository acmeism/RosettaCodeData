import "std/io.zc"
import "std/string.zc"

fn main(argc: int, argv: char**) {
    // Check if the user passed the line-by-line flag
    let line_mode = argc > 1 && strcmp(argv[1], "-l") == 0;

    while true {
        // readln() dynamically allocates and returns NULL on EOF
        let line = readln();
        if line == NULL break;

        // Ensure the line buffer is freed at the end of the current scope
        defer free(line);

        if line_mode {
            println "Line: [{line}]";
        } else {
            let s = String::from(line);
            let words = s.split(' ');

            for word in words {
                if !word.is_empty() {
                    let w = word.c_str();
                    println "Word: [{w}]";
                }
            }
        }
    }
}
