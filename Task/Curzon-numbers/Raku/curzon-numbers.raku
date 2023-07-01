sub curzon ($base) { lazy (1..∞).hyper.map: { $_ if (exp($_, $base) + 1) %% ($base × $_ + 1) } };

for <2 4 6 8 10> {
    my $curzon = .&curzon;
    say "\nFirst 50 Curzon numbers using a base of $_:\n" ~
      $curzon[^50].batch(10)».fmt("%4s").join("\n") ~
      "\nOne thousandth: " ~ $curzon[999]
}
