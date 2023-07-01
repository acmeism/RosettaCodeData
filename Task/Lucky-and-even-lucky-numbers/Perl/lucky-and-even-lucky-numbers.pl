use Perl6::GatherTake;

sub luck {
my($a,$b) = @_;

gather {
    my $i = $b;
    my(@taken,@rotor,$j);

    take 0; # 0th index is a placeholder
    push @taken, take $a;

    while () {
        for ($j = 0; $j < @rotor; $j++) {
            --$rotor[$j] or last;
        }
        if ($j < @rotor) {
            $rotor[$j] = $taken[$j+1];
        }
        else {
            take $i;
            push @taken, $i;
            push @rotor, $i - @taken;
        }
        $i += 2;
    }
}
}

# fiddle with user input
$j = shift || usage();
$k = shift || ',';
$l = shift || 'lucky';
usage() unless $k =~ /,|-?\d+/;
usage() unless $l =~ /^(even)?lucky$/i;
sub usage { print "Args must be:  j [,|k|-k] [lucky|evenlucky]\n" and exit }

# seed the iterator
my $lucky = $l =~ /^l/i ? luck(1,3) : luck(2,4);

# access values from 'lazy' list
if ($k eq ',') {
    print $lucky->[$j]
} elsif ($k > $j) {
    print $lucky->[$_] . ' ' for $j..$k
} elsif ($k < 0) {
    while () { last if abs($k) < $lucky->[$i++] } # must first extend the array
    print join ' ', grep { $_ >= $j and $_ <= abs($k) } @$lucky
}

print "\n"
