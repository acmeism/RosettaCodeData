use strict;
use warnings;
use List::Util 'max';

sub distribution {
    my %param = ( function => \&{scalar sub {return 1}}, sample_size => 1e5, @_);
    my @values;
    do {
        my($r1, $r2) = (rand, rand);
        push @values, $r1 if &{$param{function}}($r1) > $r2;
    } until @values == $param{sample_size};
    wantarray ? @values : \@values;
}

sub modifier_notch {
    my($x) = @_;
    return 2 * ( $x < 1/2 ? ( 1/2 - $x  )
                          : ( $x  - 1/2 ) );
}

sub print_histogram {
    our %param = (n_bins => 10, width => 80, @_);
    my %counts;
    $counts{ int($_ * $param{n_bins}) / $param{n_bins} }++ for @{$param{data}};
    our $max_value = max values %counts;
    print "Bin  Counts  Histogram\n";
    printf "%4.2f %6d: %s\n", $_, $counts{$_}, hist($counts{$_}) for sort keys %counts;
    sub hist { scalar ('■') x ( $param{width} * $_[0] / $max_value ) }
}

print_histogram( data => \@{ distribution() } );
print "\n\n";

my @samples = distribution( function => \&modifier_notch, sample_size => 50_000);
print_histogram( data => \@samples, n_bins => 20, width => 64);
