use strict;
use warnings;
use feature 'say';
use experimental 'signatures';
use List::Util qw(sum);
use ntheory 'todigits';

{
    package Point;
    use Class::Struct;
    struct( x => '$', y => '$',);
}

use constant pi => 2 * atan2(1, 0);
use enum qw(False True);

my @twelvesteps = map { Point->new( x => sin(pi * $_/6), y => cos(pi * $_/6) ) } 1 .. 12;
my @foursteps   = map { Point->new( x => sin(pi * $_/2), y => cos(pi * $_/2) ) } 1 ..  4;

sub add ($p, $q) { Point->new( x => $p->x + $q->x , y => $p->y + $q->y) }

sub approx_eq ($p, $q) { use constant eps => .0001; abs($p->x - $q->x)<eps and abs($p->y - $q->y)<eps }

sub digits($n, $base, $pad=0) {
    my @output = reverse todigits($n, $base);
    push @output, (0) x ($pad - +@output) if $pad > +@output;
    @output
}

sub rotate { my($i,@a) = @_; @a[$i .. @a-1, 0 .. $i-1] }

sub circularsymmetries(@c) { map { join ' ', rotate($_, @c) } 0 .. $#c }

sub addsymmetries($infound, @turns) {
    my @allsym;
    push @allsym, circularsymmetries(@turns);
    push @allsym, circularsymmetries(map { -1 * $_ } @turns);
    $$infound{$_} = True for @allsym;
    (sort @allsym)[-1]
}

sub isclosedpath($straight, @turns) {
    my $start = Point->new(x=> 0, y =>0);
    return False if sum(@turns) % ($straight ? 4 : 12);
    my ($angl, $point) = (0, $start);
    for my $turn (@turns) {
        $angl  += $turn;
        $point = add($point, $straight ? $foursteps[$angl % 4] : $twelvesteps[$angl % 12]);
    }
    approx_eq($point, $start);
}

sub allvalidcircuits($N, $doPrint = False, $straight = False) {
    my ( @found, %infound );
    say "\nFor N of ". $N . ' and ' . ($straight ? 'straight' : 'curved') . ' track:';
    for my $i (0 .. ($straight ? 3 : 2)**$N - 1) {
        my @turns = $straight ?
            map { $_ == 0 ?  0 : ($_ == 1 ? -1 : 1) } digits($i,3,$N) :
            map { $_ == 0 ? -1 :                 1  } digits($i,2,$N);
        if (isclosedpath($straight, @turns) && ! exists $infound{join ' ', @turns} ) {
            my $canon = addsymmetries(\%infound, @turns);
            push @found, $canon;
        }
    }
    say join "\n", @found if $doPrint;
    say "There are " . +@found . ' unique valid circuits.';
    @found
}

allvalidcircuits($_, True)       for 12, 16, 20;
allvalidcircuits($_, True, True) for 4, 6, 8;
