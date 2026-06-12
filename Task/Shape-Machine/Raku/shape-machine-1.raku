my $input = (+prompt()).FatRat;
my $previous = 0.FatRat;
my $count;
my $places = 36;
loop {
    $input += 3;
    $input ×= .86;
    last if $previous.substr(0,$places) eq $input.substr(0,$places);
    ++$count;
    say ($previous = $input).substr(0,$places);
}
say "$count repetitions";
