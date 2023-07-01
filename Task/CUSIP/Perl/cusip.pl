$cv{$_} = $i++ for '0'..'9', 'A'..'Z', '*', '@', '#';

sub cusip_check_digit {
    my @cusip = split m{}xms, shift;
    my $sum = 0;

    for $i (0..7) {
        return 'Invalid character found' unless $cusip[$i] =~ m{\A [[:digit:][:upper:]*@#] \z}xms;
        $v  = $cv{ $cusip[$i] };
        $v *= 2 if $i%2;
        $sum += int($v/10) + $v%10;
    }

    $check_digit = (10 - ($sum%10)) % 10;
    $check_digit == $cusip[8] ? '' : ' (incorrect)';
}

my %test_data = (
    '037833100' => 'Apple Incorporated',
    '17275R102' => 'Cisco Systems',
    '38259P508' => 'Google Incorporated',
    '594918104' => 'Microsoft Corporation',
    '68389X106' => 'Oracle Corporation',
    '68389X105' => 'Oracle Corporation',
);

print "$_ $test_data{$_}" . cusip_check_digit($_) . "\n" for sort keys %test_data;
