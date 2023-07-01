use Math::Cartesian::Product;

# Pregenerate all forward and reverse translations
sub playfair {
    our($key,$from) = @_;
    $from //= 'J';
    our $to = $from eq 'J' ? 'I' : '';
    my(%ENC,%DEC,%seen,@m);

    sub canon {
        my($str) = @_;
        $str =~ s/[^[:alpha:]]//g;
        $str =~ s/$from/$to/gi;
        uc $str;
    }

    my @uniq = grep { ! $seen{$_}++ } split '', canon($key . join '', 'A'..'Z');
    while (@uniq) { push @m, [splice @uniq, 0, 5] }

    # Map pairs in same row.
    for my $r (@m)  {
        for my $x (cartesian {@_} [0..4], [0..4]) {
        my($i,$j) = @$x;
        next if $i == $j;
        $ENC{ @$r[$i] . @$r[$j] } =  @$r[($i+1)%5] . @$r[($j+1)%5];
        }
    }

    # Map pairs in same column.
    for my $c (0..4) {
        my @c = map { @$_[$c] } @m;
        for my $x (cartesian {@_} [0..4], [0..4]) {
        my($i,$j) = @$x;
        next if $i == $j;
        $ENC{ $c[$i] . $c[$j] } = $c[($i+1)%5] . $c[($j+1)%5];
        }
    }

    # Map pairs with cross-connections.
    for my $x (cartesian {@_} [0..4], [0..4], [0..4], [0..4]) {
        my($i1,$j1,$i2,$j2) = @$x;
        next if $i1 == $i2 or $j1 == $j2;
        $ENC{ $m[$i1][$j1] . $m[$i2][$j2] } = $m[$i1][$j2] . $m[$i2][$j1];
    }

    # Generate reverse translations.
     while (my ($k, $v) = each %ENC) { $DEC{$v} = $k }

    # Return code-refs for encoding/decoding routines
    return
    sub { my($red) = @_; # encode
        my $str = canon($red);

        my @list;
        while ($str =~ /(.)(?(?=\1)|(.?))/g) {
            push @list, substr($str,$-[0], $-[2] ? 2 : 1);
        }
        join ' ', map { length($_)==1 ? $ENC{$_.'X'} : $ENC{$_} } @list;
    },
    sub { my($black) = @_; # decode
        join ' ', map { $DEC{$_} } canon($black) =~ /../g;
    }
}

my($encode,$decode) = playfair('Playfair example');

my $orig  = "Hide the gold in...the TREESTUMP!!!";
my $black = &$encode($orig);
my $red   = &$decode($black);
print " orig:\t$orig\n";
print "black:\t$black\n";
print "  red:\t$red\n";
