open FH, "< $filename" or die "can't open file: $!";
while (my $line = <FH>) {
    chomp $line; # removes trailing newline
    # process $line
}
close FH or die "can't close file: $!";
