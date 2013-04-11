my $d5 = 1..5;
sub d5() { $d5.roll; }  # 1d5

sub d7() {
    my $flat = 21;
    $flat = 5 * d5() - d5() until $flat < 21;
    $flat % 7 + 1;
}
