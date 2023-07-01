use Math::SimpleHisto::XS;

for (@tests) {
    my @lim = (0, @{$$_{limits}}, Inf);
    my $hist = Math::SimpleHisto::XS->new( bins => \@lim );
    $hist->fill( \$$_{data}->@* );
    my $data_bins = $hist->all_bin_contents;
    printf "[%3d, %3d) => %3d\n", $lim[$_], ($lim[$_+1] == Inf ? 'Inf' : $lim[$_+1]), $$data_bins[$_] for 0..@lim-2;
    print "\n";
}
