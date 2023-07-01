use List::Util qw(min max first);

sub sufficate {
    my($val, $type, $round) = @_;
    $type //= 'M';
   if ($type =~ /^\d$/) { $round = $type; $type = 'M' }

    my $s = '';
    if (substr($val,0,1) eq '-') { $s = '-'; $val = substr $val, 1 }
    $val =~ s/,//g;
    if ($val =~ m/e/i) {
        my ($m,$e) = split /[eE]/, $val;
        $val = ($e < 0) ? $m * 10**-$e : $m * 10**$e;
    }

    my %s;
    if ($type eq 'M') {
        my @x = qw<K M G T P E Z Y X W V U>;
        $s{$x[$_]} = 1000 * 10 ** ($_*3) for 0..$#x
    } elsif ($type eq 'B') {
        my @x = qw<Ki Mi Gi Ti Pi Ei Zi Yi Xi Wi Vi Ui>;
        $s{$x[$_]} = 2 ** (10*($_+1)) for 0..$#x
    } elsif ($type eq 'G') {
        $s{'googol'} = 10**100
    } else {
        return 'What we have here is a failure to communicate...'
    }

    my $k;
    if (abs($val) < (my $m = min values %s)) {
        $k = first { $s{$_} == $m } keys %s;
    } elsif (abs($val) > (my $x = max values %s)) {
        $k = first { $s{$_} == $x } keys %s;
    } else {
        for my $key (sort { $s{$a} <=> $s{$b} } keys %s) {
            next unless abs($val)/$s{$key} < min values %s;
            $k = $key;
            last;
        }
    }

    my $final = abs($val)/$s{$k};
    $final = round($final,$round) if defined $round;
    $s . $final . $k
}

sub round {
    my($num,$dig) = @_;
    if    ($dig == 0) { int 0.5 + $num }
    elsif ($dig  < 0) { 10**-$dig * int(0.5 + $num/10**-$dig) }
    else              { my $fmt = '%.' . $dig . 'f'; sprintf $fmt, $num }
}

sub comma {
    my($i) = @_;
    my ($whole, $frac) = split /\./, $i;
    (my $s = reverse $whole) =~ s/(.{3})/$1,/g;
    ($s = reverse $s) =~ s/^,//;
    $frac = $frac.defined ? ".$frac" : '';
    return "$s$frac";
}

my @tests = (
   '87,654,321',
   '-998,877,665,544,332,211,000 3',
   '+112,233 0',
   '16,777,216 1',
   '456,789,100,000,000',
   '456,789,100,000,000 M 2',
   '456,789,100,000,000 B 5',
   '456,789,100,000.000e+00 M 0',
   '+16777216 B',
   '1.2e101 G',
   '347,344 M -2', # round to -2 past the decimal
   '1122334455 Q', # bad unit type example
);

printf "%33s : %s\n", $_, sufficate(split ' ', $_) for @tests;
