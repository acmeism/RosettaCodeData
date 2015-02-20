sub lis {
    my @l = map [], 1 .. @_;
    push @{$l[0]}, +$_[0];
    for my $i (1 .. @_-1) {
        for my $j (0 .. $i - 1) {
            if ($_[$j] < $_[$i] and @{$l[$i]} < @{$l[$j]} + 1) {
                $l[$i] = [ @{$l[$j]} ];
            }
        }
        push @{$l[$i]}, $_[$i];
    }
    my ($max, $l) = 0, [];
    for (@l) {
        ($max, $l) = (scalar(@$_), $_) if @$_ > $max;
    }
    return @$l;
}

print join ' ', lis 3, 2, 6, 4, 5, 1;
print join ' ', lis 0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15;
