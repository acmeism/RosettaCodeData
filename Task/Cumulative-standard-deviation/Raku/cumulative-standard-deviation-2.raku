sub stddev($x) {
    sqrt
        ( .[2] += $x²) / ++.[0]
      - ((.[1] += $x ) /   .[0])²
    given state @;
}

say .&stddev for <2 4 4 4 5 5 7 9>;
