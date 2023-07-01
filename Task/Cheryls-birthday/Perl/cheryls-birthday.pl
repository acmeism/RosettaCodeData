sub filter {
    my($test,@dates) = @_;
    my(%M,%D,@filtered);

    # analysis of potential birthdays, keyed by month and by day
    for my $date (@dates) {
        my($mon,$day) = split '-', $date;
        $M{$mon}{cnt}++;
        $D{$day}{cnt}++;
        push @{$M{$mon}{day}},  $day;
        push @{$D{$day}{mon}},  $mon;
        push @{$M{$mon}{bday}}, "$mon-$day";
        push @{$D{$day}{bday}}, "$mon-$day";
    }

    # eliminates May/Jun dates based on 18th and 19th being singletons
    if ($test eq 'singleton') {
        my %skip;
        for my $day (grep { $D{$_}{cnt} == 1 } keys %D) { $skip{ @{$D{$day}{mon}}[0] }++    }
        for my $mon (grep { ! $skip{$_}      } keys %M) { push @filtered, @{$M{$mon}{bday}} }

    # eliminates Jul/Aug 14th because day count > 1 across months
    } elsif ($test eq 'duplicate') {
        for my $day (grep { $D{$_}{cnt} == 1 } keys %D) { push @filtered, @{$D{$day}{bday}} }

    # eliminates Aug 15th/17th because day count > 1, within month
    } elsif ($test eq 'multiple') {
        for my $day (grep { $M{$_}{cnt} == 1 } keys %M) { push @filtered, @{$M{$day}{bday}} }
    }
    return @filtered;
}

# doesn't matter what order singleton/duplicate tests are run, but 'multiple' must be last;
my @dates = qw<5-15 5-16 5-19 6-17 6-18 7-14 7-16 8-14 8-15 8-17>;
@dates = filter($_, @dates) for qw<singleton duplicate multiple>;

my @months = qw<_ January February March April May June July August September October November December>;

my ($m, $d) = split '-', $dates[0];
print "Cheryl's birthday is $months[$m] $d.\n";
