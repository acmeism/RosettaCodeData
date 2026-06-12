for 0/1, 1/1, 1/3, 1/7, -83/60, 1/17, 10/13, 3227/555, 5**21/2**63, 1/149, 1/5261 -> $rat {
    printf "%35s - Period is %-5s: %s%s\n", $rat.nude.join('/'), .[1].chars, .[0], (.[1].comb Z~ "\c[COMBINING OVERLINE]" xx *).join
        given $rat.base-repeating
}
