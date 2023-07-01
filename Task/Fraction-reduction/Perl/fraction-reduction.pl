use strict;
use warnings;
use feature 'say';
use List::Util qw<sum uniq uniqnum head tail>;

for my $exp (map { $_ - 1 } <2 3 4>) {
    my %reduced;
    my $start = sum map { 10 ** $_ * ($exp - $_ + 1) } 0..$exp;
    my $end   = 10**($exp+1) - -1 + sum map { 10 ** $_ * ($exp - $_) } 0..$exp-1;

    for my $den ($start .. $end-1) {
        next if $den =~ /0/ or (uniqnum split '', $den) <= $exp;
        for my $num ($start .. $den-1) {
            next if $num =~ /0/ or (uniqnum split '', $num) <= $exp;
            my %i;
            map { $i{$_}++ } (uniq head -1, split '',$den), uniq tail -1, split '',$num;
            my @set = grep { $_ if $i{$_} > 1 } keys %i;
            next if @set < 1;
            for (@set) {
                (my $ne = $num) =~ s/$_//;
                (my $de = $den) =~ s/$_//;
                if ($ne/$de == $num/$den) {
                    $reduced{"$num/$den:$_"} = "$ne/$de";
                }
            }
        }
    }
    my $digit = $exp + 1;
    say "\n" . +%reduced . " $digit-digit reducible fractions:";
    for my $n (1..9) {
        my $cnt = scalar grep { /:$n/ } keys %reduced;
        say "$cnt with removed $n" if $cnt;
    }
    say "\n  12 (or all, if less) $digit-digit reducible fractions:";
    for my $f (head 12, sort keys %reduced) {
        printf "    %s => %s removed %s\n", substr($f,0,$digit*2+1), $reduced{$f}, substr($f,-1)
    }
}
