open my $fh, $filename;
my $text = do { local( $/ ); <$fh> };
close $fh;
