my $fields = 49;

my ($good-records, %dates) = 0;
for 1 .. * Z $*IN.lines -> $line, $s {
    my @fs = split /\s+/, $s;
    @fs == $fields or die "$line: Bad number of fields";
    given shift @fs {
        m/\d**4 \- \d**2 \- \d**2/ or die "$line: Bad date format";
        ++%dates{$_};
    }
    my $all-flags-okay = True;
    for @fs -> $val, $flag {
        $val ~~ /\d+ \. \d+/ or die "$line: Bad value format";
        $flag ~~ /^ \-? \d+/ or die "$line: Bad flag format";
        $flag < 1 and $all-flags-okay = False;
    }
    $all-flags-okay and ++$good-records;
}

say 'Good records: ', $good-records;
say 'Repeated timestamps:';
say '  ', $_ for grep { %dates{$_} > 1 }, sort keys %dates;
