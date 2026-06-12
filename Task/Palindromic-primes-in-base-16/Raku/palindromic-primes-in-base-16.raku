say "{+$_} matching numbers:\n{.batch(10)».fmt('%3X').join: "\n"}"
    given (^500).grep: { .is-prime and .base(16) eq .base(16).flip };
