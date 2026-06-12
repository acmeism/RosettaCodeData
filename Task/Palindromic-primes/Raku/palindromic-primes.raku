say "{+$_} matching numbers:\n{.batch(10)».fmt('%3d').join: "\n"}"
    given (^1000).grep: { .is-prime and $_ eq .flip };
