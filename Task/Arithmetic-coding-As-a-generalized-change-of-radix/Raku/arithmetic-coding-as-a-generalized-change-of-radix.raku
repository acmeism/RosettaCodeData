sub cumulative_freq(%freq) {
    my %cf;
    my $total = 0;
    for %freq.keys.sort -> $c {
        %cf{$c} = $total;
        $total += %freq{$c};
    }
    return %cf;
}

sub arithmethic_coding($str, $radix) {
    my @chars = $str.comb;

    # The frequency characters
    my %freq;
    %freq{$_}++ for @chars;

    # The cumulative frequency table
    my %cf = cumulative_freq(%freq);

    # Base
    my $base = @chars.elems;

    # Lower bound
    my $L = 0;

    # Product of all frequencies
    my $pf = 1;

    # Each term is multiplied by the product of the
    # frequencies of all previously occurring symbols
    for @chars -> $c {
        $L = $L*$base + %cf{$c}*$pf;
        $pf *= %freq{$c};
    }

    # Upper bound
    my $U = $L + $pf;

    my $pow = 0;
    loop {
        $pf div= $radix;
        last if $pf == 0;
        ++$pow;
    }

    my $enc = ($U - 1) div ($radix ** $pow);
    ($enc, $pow, %freq);
}

sub arithmethic_decoding($encoding, $radix, $pow, %freq) {

    # Multiply encoding by radix^pow
    my $enc = $encoding * $radix**$pow;

    # Base
    my $base = [+] %freq.values;

    # Create the cumulative frequency table
    my %cf = cumulative_freq(%freq);

    # Create the dictionary
    my %dict;
    for %cf.kv -> $k,$v {
        %dict{$v} = $k;
    }

    # Fill the gaps in the dictionary
    my $lchar;
    for ^$base -> $i {
        if (%dict{$i}:exists) {
            $lchar = %dict{$i};
        }
        elsif (defined $lchar) {
            %dict{$i} = $lchar;
        }
    }

    # Decode the input number
    my $decoded = '';
    for reverse(^$base) -> $i {

        my $pow = $base**$i;
        my $div = $enc div $pow;

        my $c  = %dict{$div};
        my $fv = %freq{$c};
        my $cv = %cf{$c};

        my $rem = ($enc - $pow*$cv) div $fv;

        $enc = $rem;
        $decoded ~= $c;
    }

    # Return the decoded output
    return $decoded;
}

my $radix = 10;    # can be any integer greater or equal with 2

for <DABDDB DABDDBBDDBA ABRACADABRA TOBEORNOTTOBEORTOBEORNOT> -> $str {
    my ($enc, $pow, %freq) = arithmethic_coding($str, $radix);
    my $dec = arithmethic_decoding($enc, $radix, $pow, %freq);

    printf("%-25s=> %19s * %d^%s\n", $str, $enc, $radix, $pow);

    if ($str ne $dec) {
        die "\tHowever that is incorrect!";
    }
}
