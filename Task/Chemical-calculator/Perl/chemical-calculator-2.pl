use strict;
use warnings;
my %atomic_weight = < H 1.008 C 12.011 O 15.999 Na 22.99 S 32.06 >;

sub molar_mass {
    my($mf) = @_;
    my(%count,$mass);
    my $mf_orig = $mf;
    my $mf_std;

    # expand repeated groups
    $mf =~ s/(.*)\((.*?)\)(\d*)/$1 . $2 x ($3 ? $3 : 1) /e while $mf =~ m/\(/;

    # totals for each atom type
    $mf =~ s/([A-Z][a-z]{0,2})(\d*)/ $count{$1} += $2 ? $2 : 1/eg;

    # calculate molar mass and display, along with standardized MF and original MF
    $mass += $count{$_}*$atomic_weight{"$_"} for sort keys %count;
    $mf_std .= 'C' . $count{C} if $count{C};
    $mf_std .= 'H' . $count{H} if $count{H};
    $mf_std .= $_  . $count{$_} for grep { $_ ne 'C' and $_ ne 'H' } sort keys %count;
    $mf     .= $count{$_} * $atomic_weight{$_} for sort keys %count;
    printf "%7.3f %-9s %s\n", $mass, $mf_std, $mf_orig;
}

molar_mass($_) for <H H2 H2O Na2SO4 C6H12 COOH(C(CH3)2)3CH3>
