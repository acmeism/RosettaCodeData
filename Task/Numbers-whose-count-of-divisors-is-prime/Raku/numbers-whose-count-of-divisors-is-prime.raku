use Prime::Factor;

my $ceiling = ceiling sqrt 1e5;

say display :10cols, :fmt('%6d'), (^$ceiling)».² .grep: { .&divisors.is-prime };

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
