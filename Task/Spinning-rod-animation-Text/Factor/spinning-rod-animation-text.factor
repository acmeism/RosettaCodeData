USING: calendar combinators.extras formatting io sequences
threads ;

[
    "\\|/-" [ "%c\r" printf flush 1/4 seconds sleep ] each
] forever
