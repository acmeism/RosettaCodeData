use Lingua::EN::Numbers;

sub mdr { ($^n, {.comb.&prod} … *.chars == 1).tail }
sub dr  { ($^n, {.comb.sum} … *.chars == 1).tail }
sub prod { [*] @_ }

sub is-dividuus ($_) {
    !.contains(0) && ($_ %% .comb.sum) && ($_ %% .comb.&prod) && ($_ %% .&dr) && ($_ %% .&mdr)
}

put "First fifty Dividuus numbers:\n", (1..*).grep(&is-dividuus)[^50].batch(10)».fmt("%5d").join: "\n";

printf "\nDividuus numbers between %s and %s:\n", 9.9e8.Int.&comma, 1e9.Int.&comma;
put (9.9e8..1e9).hyper(:50000batch).map({ $_ if .&is-dividuus })».Int».&comma;
