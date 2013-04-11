sub roots_of_unity (Int $n where { $n > 0 }) {
    map { exp 2i * pi/$n * $_ }, ^$n
}

printf "% .5f + % .5fi\n", .re, .im for roots_of_unity 10;
