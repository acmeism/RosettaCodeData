use strict;
use warnings;
use feature 'say';

my @cyl;
my $shots = 6;

sub load  {
    push @cyl, shift @cyl while $cyl[1];
    $cyl[1] = 1;
    push @cyl, shift @cyl
}

sub spin  { push @cyl, shift @cyl for 0 .. int rand @cyl }
sub fire  { push @cyl, shift @cyl; $cyl[0] }

sub LSLSFSF {
    @cyl = (0) x $shots;
    load, spin, load, spin;
    return 1 if fire;
    spin;
    fire
}

sub LSLSFF {
    @cyl = (0) x $shots;
    load, spin, load, spin;
    fire or fire
}

sub LLSFSF {
    @cyl = (0) x $shots;
    load, load, spin;
    return 1 if fire;
    spin;
    fire
}

sub LLSFF {
    @cyl = (0) x $shots;
    load, load, spin;
    fire or fire
}

my $trials = 10000;

for my $ref (<LSLSFSF LSLSFF LLSFSF LLSFF>) {
    no strict 'refs';
    my $total = 0;
    $total += &$ref for 1..$trials;
    printf "%7s %.2f%%\n", $ref, $total / $trials * 100;
}
