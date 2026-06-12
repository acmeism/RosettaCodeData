use Prime::Factor:ver<0.3.0+>;

say "{+$_} matching numbers:\n{.batch(10)».fmt('%3d').join: "\n"}"
    given (1..^200).grep: { all .flip «%%« .&divisors».flip };
