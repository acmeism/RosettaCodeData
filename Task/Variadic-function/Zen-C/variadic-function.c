fn variadic(count: int, ...) {
    let args: va_list;
    va_start(args, count);
    for i in 0..count {
        println "{va_arg(args, string)}";
    }
    va_end(args);
}

fn main(argc: int, argv: char**) {
    // First print some hard-coded words.
    let words = ["faith", "hope", "charity"];
    variadic(3, words[0], words[1], words[2]);
    println "";

    // Now print the command line args if there's 3 of them,
    // plus the executable name (argv[0]).
    if argc == 4 {
        variadic(argc, argv[0], argv[1], argv[2], argv[3]);
    } else {
        eprintln "Please pass 3 command line arguments.";
    }
}
