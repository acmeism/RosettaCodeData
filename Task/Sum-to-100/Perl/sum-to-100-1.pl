#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my $string = '123456789';
my $length = length $string;
my @possible_ops = ("" , '+', '-');

{
    my @ops;
    sub Next {
        return @ops = (0) x ($length) unless @ops;

        my $i = 0;
        while ($i < $length) {
            if ($ops[$i]++ > $#possible_ops - 1) {
                $ops[$i++] = 0;
                next
            }
            # + before the first number
            next if 0 == $i && '+' eq $possible_ops[ $ops[0] ];

            return @ops
        }
        return
    }
}

sub evaluate {
    my ($expression) = @_;
    my $sum;
    $sum += $_ for $expression =~ /([-+]?[0-9]+)/g;
    return $sum
}

my %count = ( my $max_count = 0 => 0 );

say 'Show all solutions that sum to 100';

while (my @ops = Next()) {
    my $expression = "";
    for my $i (0 .. $length - 1) {
        $expression .= $possible_ops[ $ops[$i] ];
        $expression .= substr $string, $i, 1;
    }
    my $sum = evaluate($expression);
    ++$count{$sum};
    $max_count = $sum if $count{$sum} > $count{$max_count};
    say $expression if 100 == $sum;
}

say 'Show the sum that has the maximum number of solutions';
say "sum: $max_count; solutions: $count{$max_count}";

my $n = 1;
++$n until ! exists $count{$n};
say "Show the lowest positive sum that can't be expressed";
say $n;

say 'Show the ten highest numbers that can be expressed';
say for (sort { $b <=> $a } keys %count)[0 .. 9];
