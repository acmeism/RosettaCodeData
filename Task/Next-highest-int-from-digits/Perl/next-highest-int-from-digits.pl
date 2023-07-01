use strict;
use warnings;
use feature 'say';
use bigint;
use List::Util 'first';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub next_greatest_index {
    my($str) = @_;
    my @i = reverse split //, $str;
    @i-1 - (1 + first { $i[$_] > $i[$_+1] } 0 .. @i-1);
}

sub next_greatest_integer {
    my($num) = @_;
    my $numr;
    return 0 if length $num < 2;
    return ($numr = 0 + reverse $num) > $num ? $numr : 0 if length $num == 2;
    return 0 unless my $i = next_greatest_index( $num ) // 0;
    my $digit = substr($num, $i, 1);
    my @rest  = sort split '', substr($num, $i);
    my $next  = first { $rest[$_] > $digit } 1..@rest;
    join '', substr($num, 0, $i), (splice(@rest, $next, 1)), @rest;
}

say 'Next largest integer able to be made from these digits, or zero if no larger exists:';

for (0, 9, 12, 21, 12453, 738440, 45072010, 95322020, 9589776899767587796600, 3345333) {
    printf "%30s  ->  %s\n", comma($_), comma next_greatest_integer $_;
}
