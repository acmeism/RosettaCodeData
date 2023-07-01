use strict;
use warnings;
use feature 'say';
use POSIX 'fmod';

my $tau = 2 * 4*atan2(1, 1);
my @units = (
    { code => 'd', name => 'degrees' , number =>  360 },
    { code => 'g', name => 'gradians', number =>  400 },
    { code => 'm', name => 'mills'   , number => 6400 },
    { code => 'r', name => 'radians' , number => $tau },
);

my %cvt;
for my $a (@units) {
  for my $b (@units) {
    $cvt{ "${$a}{code}2${$b}{code}" } = sub {
        my($angle) = shift;
        my $norm = fmod($angle,${$a}{number}); # built-in '%' returns only integers
        $norm -= ${$a}{number} if $angle < 0;
        $norm * ${$b}{number} / ${$a}{number}
        }
  }
}

printf '%s'. '%12s'x4 . "\n", '     Angle Unit    ', <Degrees Gradians Mills Radians>;
for my $angle (-2, -1, 0, 1, 2, $tau, 16, 360/$tau, 360-1, 400-1, 6400-1, 1_000_000) {
    print "\n";
    for my $from (@units) {
        my @sub_keys = map { "${$from}{code}2${$_}{code}" } @units;
        my @results  = map { &{$cvt{$_}}($angle) } @sub_keys;
        printf '%10g %-8s' . '%12g'x4 . "\n", $angle, ${$from}{name}, @results;
    }
}
