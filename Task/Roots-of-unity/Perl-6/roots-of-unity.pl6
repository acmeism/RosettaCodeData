sub roots-of-unity (Int \n where 1..*) {
    map { exp 2i * pi/n * $_ }, ^n;
}

printf "%+.5f%+.5fi\n", .reals for roots-of-unity 10;
