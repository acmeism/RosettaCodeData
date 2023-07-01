sub MAIN ($infile) {
    $infile.IO.lines ==> printer() ==> my $count;
    say "printed $count lines";
}

sub printer(*@lines) {
    my $lines;
    for @lines {
	.say;
	++$lines;
    }
    $lines;
}
