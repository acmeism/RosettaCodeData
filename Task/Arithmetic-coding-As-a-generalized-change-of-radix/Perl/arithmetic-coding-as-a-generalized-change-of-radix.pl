use Math::BigInt (try => 'GMP');

sub cumulative_freq {
    my ($freq) = @_;

    my %cf;
    my $total = Math::BigInt->new(0);
    foreach my $c (sort keys %$freq) {
        $cf{$c} = $total;
        $total += $freq->{$c};
    }

    return %cf;
}

sub arithmethic_coding {
    my ($str, $radix) = @_;
    my @chars = split(//, $str);

    # The frequency characters
    my %freq;
    $freq{$_}++ for @chars;

    # The cumulative frequency table
    my %cf = cumulative_freq(\%freq);

    # Base
    my $base = Math::BigInt->new(scalar @chars);

    # Lower bound
    my $L = Math::BigInt->new(0);

    # Product of all frequencies
    my $pf = Math::BigInt->new(1);

    # Each term is multiplied by the product of the
    # frequencies of all previously occurring symbols
    foreach my $c (@chars) {
        $L->bmuladd($base, $cf{$c} * $pf);
        $pf->bmul($freq{$c});
    }

    # Upper bound
    my $U = $L + $pf;

    my $pow = Math::BigInt->new($pf)->blog($radix);
    my $enc = ($U - 1)->bdiv(Math::BigInt->new($radix)->bpow($pow));

    return ($enc, $pow, \%freq);
}

sub arithmethic_decoding {
    my ($enc, $radix, $pow, $freq) = @_;

    # Multiply enc by radix^pow
    $enc *= $radix**$pow;

    # Base
    my $base = Math::BigInt->new(0);
    $base += $_ for values %{$freq};

    # Create the cumulative frequency table
    my %cf = cumulative_freq($freq);

    # Create the dictionary
    my %dict;
    while (my ($k, $v) = each %cf) {
        $dict{$v} = $k;
    }

    # Fill the gaps in the dictionary
    my $lchar;
    foreach my $i (0 .. $base - 1) {
        if (exists $dict{$i}) {
            $lchar = $dict{$i};
        }
        elsif (defined $lchar) {
            $dict{$i} = $lchar;
        }
    }

    # Decode the input number
    my $decoded = '';
    for (my $pow = $base**($base - 1) ; $pow > 0 ; $pow /= $base) {
        my $div = $enc / $pow;

        my $c  = $dict{$div};
        my $fv = $freq->{$c};
        my $cv = $cf{$c};

        $enc = ($enc - $pow * $cv) / $fv;
        $decoded .= $c;
    }

    # Return the decoded output
    return $decoded;
}

my $radix = 10;    # can be any integer greater or equal with 2

foreach my $str (qw(DABDDB DABDDBBDDBA ABRACADABRA TOBEORNOTTOBEORTOBEORNOT)) {
    my ($enc, $pow, $freq) = arithmethic_coding($str, $radix);
    my $dec = arithmethic_decoding($enc, $radix, $pow, $freq);

    printf("%-25s=> %19s * %d^%s\n", $str, $enc, $radix, $pow);

    if ($str ne $dec) {
        die "\tHowever that is incorrect!";
    }
}
