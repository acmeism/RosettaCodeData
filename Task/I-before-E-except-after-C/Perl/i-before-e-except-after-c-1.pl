#!/usr/bin/perl
use warnings;
use strict;

sub result {
    my ($support, $against) = @_;
    my $ratio  = sprintf '%.2f', $support / $against;
    my $result = $ratio >= 2;
    print "$support / $against = $ratio. ", 'NOT ' x !$result, "PLAUSIBLE\n";
    return $result;
}

my @keys  = qw(ei cei ie cie);
my %count;

while (<>) {
    for my $k (@keys) {
        $count{$k}++ if -1 != index $_, $k;
    }
}

my ($support, $against, $result);

print 'I before E when not preceded by C: ';
$support = $count{ie} - $count{cie};
$against = $count{ei} - $count{cei};
$result += result($support, $against);

print 'E before I when preceded by C: ';
$support = $count{cei};
$against = $count{cie};
$result += result($support, $against);

print 'Overall: ', 'NOT ' x ($result < 2), "PLAUSIBLE.\n";
