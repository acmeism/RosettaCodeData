my $upto = 1e4;

for 1,3,5,7,9 -> $bracket {
    print "\nPrimes up to $upto bracketed by $bracket - ";
    say display ^$upto .grep: { .starts-with($bracket) && .ends-with($bracket) && .is-prime }
}

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
