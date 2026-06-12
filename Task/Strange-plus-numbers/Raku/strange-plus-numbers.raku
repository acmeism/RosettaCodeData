unit sub MAIN ($start = 100, $end = 500);
put +$_, " matching numbers from $start to $end:\n", $_ given
  ($start .. $end).hyper(:256batch,:8degree).grep: { all .comb.rotor(2 => -1).map: { .sum.is-prime } };
