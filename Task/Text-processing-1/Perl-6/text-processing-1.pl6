my @gaps;
my $previous = 'valid';

for $*IN.lines -> $line {
    my ($date, @readings) = split /\s+/, $line;
    my @valid;
    my $hour = 0;
    for @readings -> $reading, $flag {
        if $flag > 0 {
            @valid.push($reading);
            if $previous eq 'invalid' {
                @gaps[*-1]{'end'} = "$date $hour:00";
                $previous = 'valid';
            }
        }
        else
        {
            if $previous eq 'valid' {
                @gaps.push( {start => "$date $hour:00"} );
            }
            @gaps[*-1]{'count'}++;
            $previous = 'invalid';
        }
        $hour++;
    }
    say "$date: { ( +@valid ?? ( ( [+] @valid ) / +@valid ).fmt("%.3f") !! 0 ).fmt("%8s") }",
        " mean from { (+@valid).fmt("%2s") } valid.";
};

my $longest = @gaps.sort({-$^a<count>})[0];

say "Longest period of invalid readings was {$longest<count>} hours,\n",
    "from {$longest<start>} till {$longest<end>}."
