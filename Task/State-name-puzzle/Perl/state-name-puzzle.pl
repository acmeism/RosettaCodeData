#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };


sub uniq {
    my %uniq;
    undef @uniq{ @_ };
    return keys %uniq
}


sub puzzle {
    my @states = uniq(@_);

    my %pairs;
    for my $state1 (@states) {
        for my $state2 (@states) {
            next if $state1 le $state2;
            my $both = join q(),
                       grep ' ' ne $_,
                       sort split //,
                       lc "$state1$state2";
            push @{ $pairs{$both} }, [ $state1, $state2 ];
        }
    }

    for my $pair (keys %pairs) {
        next if 2 > @{ $pairs{$pair} };

        for my $pair1 (@{ $pairs{$pair} }) {
            for my $pair2 (@{ $pairs{$pair} }) {
                next if 4 > uniq(@$pair1, @$pair2)
                     or $pair1->[0] lt $pair2->[0];

                say join ' = ', map { join ' + ', @$_ } $pair1, $pair2;
            }
        }
    }
}

my @states = ( 'Alabama', 'Alaska', 'Arizona', 'Arkansas',
               'California', 'Colorado', 'Connecticut', 'Delaware',
               'Florida', 'Georgia', 'Hawaii',
               'Idaho', 'Illinois', 'Indiana', 'Iowa',
               'Kansas', 'Kentucky', 'Louisiana',
               'Maine', 'Maryland', 'Massachusetts', 'Michigan',
               'Minnesota', 'Mississippi', 'Missouri', 'Montana',
               'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
               'New Mexico', 'New York', 'North Carolina', 'North Dakota',
               'Ohio', 'Oklahoma', 'Oregon',
               'Pennsylvania', 'Rhode Island',
               'South Carolina', 'South Dakota', 'Tennessee', 'Texas',
               'Utah', 'Vermont', 'Virginia',
               'Washington', 'West Virginia', 'Wisconsin', 'Wyoming',
             );

my @fictious = ( 'New Kory', 'Wen Kory', 'York New', 'Kory New', 'New Kory' );

say scalar @states, ' states:';
puzzle(@states);

say @states + @fictious, ' states:';
puzzle(@states, @fictious);
