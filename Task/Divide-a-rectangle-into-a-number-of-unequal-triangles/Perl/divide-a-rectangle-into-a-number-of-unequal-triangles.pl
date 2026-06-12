use strict;
use warnings;
use feature 'say';
use List::Util 'sum';

sub UnequalDivider {
    my($L,$H,$N) = @_;
    die unless $N > 2;
    return (0,$H), (0,0), ((2/5)*$L,$H), ($L,0), ($L,$H) if $N == 3;

    my ($fail,%unique,%ratios,@base,@roof,$bTotal,$rTotal);

    do {
        $fail   = 0;
        %unique =  %ratios = () ;
        ++$unique{int(rand 2*$N) + 1} while keys %unique < $N;
        my @segments      = keys %unique;
        @base             = @segments[   0 ..     $N/2-1];
        @roof             = @segments[$N/2 .. $#segments];
        ($bTotal,$rTotal) = (  sum(@base),  sum(@roof)  );
        ++$ratios{$_/$bTotal} for (@base);
        for (@roof) { if ( exists($ratios{$_/$rTotal}) ) { $fail = 1 && last } }
   } until ( $fail == 0 );

   my ($bPartial,$rPartial) = ( shift(@base), shift(@roof) );
   my @vertices = ([0,$H], [0,0], [($rPartial/$rTotal)*$L,$H]);

    for (0 .. @base) {
        push @vertices, [$bPartial/$bTotal*$L,0];
        if (@base == 1) {
            0 == $N%2 ? return @vertices, ([$L,$H], [$L,0])
                      : return @vertices, ([$L*(1-$roof[-1]/$rTotal),$H], [$L,0], [$L,$H]);
        }
        ($bPartial) += shift @base;
        ($rPartial) += shift @roof;
        push @vertices, [$rPartial/$rTotal*$L,$H];
   }
}

my @V = UnequalDivider(1000,500,7);
say sprintf( '(%.3f %.3f) 'x3, @{$V[$_]}, @{$V[++$_]}, @{$V[++$_]} ) =~ s/\.000//gr for 0 .. @V-3;
