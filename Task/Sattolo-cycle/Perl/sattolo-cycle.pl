@a = 0..30;

printf "%2d ", $_ for @a; print "\n";
sattolo_cycle(\@a);
printf "%2d ", $_ for @a; print "\n";

sub sattolo_cycle {
    my($array) = @_;
    for $i (reverse 0 .. -1+@$array) {
        my $j = int rand $i;
        @$array[$j, $i] = @$array[$i, $j];
    }
}
