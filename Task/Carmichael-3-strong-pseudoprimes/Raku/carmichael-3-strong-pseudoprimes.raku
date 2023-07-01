for (2..67).grep: *.is-prime -> \Prime1 {
    for 1 ^..^ Prime1 -> \h3 {
        my \g = h3 + Prime1;
        for 0 ^..^ h3 + Prime1 -> \d {
            if (h3 + Prime1) * (Prime1 - 1) %% d and -Prime1**2 % h3 == d % h3  {
                my \Prime2 = floor 1 + (Prime1 - 1) * g / d;
                next unless Prime2.is-prime;
                my \Prime3 = floor 1 + Prime1 * Prime2 / h3;
                next unless Prime3.is-prime;
                next unless (Prime2 * Prime3) % (Prime1 - 1) == 1;
                say "{Prime1} × {Prime2} × {Prime3} == {Prime1 * Prime2 * Prime3}";
            }
        }
    }
}
