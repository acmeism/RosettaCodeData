sub MAIN($dir = '.') {
    sub log10 (Int $s) { $s ?? $s.log(10).Int !! 0 }
    my %fsize;
    my @dirs = $dir.IO;
    while @dirs {
        for @dirs.pop.dir -> $path {
            %fsize{$path.s.&log10}++ if $path.f;
            @dirs.push: $path if $path.d and $path.r
        }
    }
    my $max = %fsize.values.max;
    my $bar-size = 80;
    say "File size distribution in bytes for directory: $dir\n";
    for 0 .. %fsize.keys.max {
          say sprintf( "# Files @ %5sb %8s: ", $_ ?? "10e{$_-1}" !! 0, %fsize{$_} // 0 ),
              histogram( $max, %fsize{$_} // 0, $bar-size )
    }
    say %fsize.values.sum, ' total files.';
}

sub histogram ($max, $value, $width = 60) {
    my @blocks = <| ▏ ▎ ▍ ▌ ▋ ▊ ▉ █>;
    my $scaled = ($value * $width / $max).Int;
    my ($end, $bar) = $scaled.polymod(8);
    (@blocks[8] x $bar * 8) ~ (@blocks[$end] if $end) ~ "\n"
}
