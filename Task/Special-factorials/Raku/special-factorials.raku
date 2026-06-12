sub postfix:<!> ($n) {   [*] 1 .. $n }
sub postfix:<$> ($n) { [R**] 1 .. $n }

sub sf ($n) { [*] map {                      $_! }, 1 .. $n }
sub H  ($n) { [*] map {                $_ ** $_  }, 1 .. $n }
sub af ($n) { [+] map { (-1) ** ($n - $_) *  $_! }, 1 .. $n }
sub rf ($n) {
    state @f = 1, |[\*] 1..*;
    $n == .value ?? .key !! Nil given @f.first: :p, * >= $n;
}

say 'sf : ', map &sf , 0..9;
say 'H  : ', map &H  , 0..9;
say 'af : ', map &af , 0..9;
say '$  : ', map *$  , 1..4;

say '5$ has ', 5$.chars, ' digits';

say 'rf : ', map &rf, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800;
say 'rf(119) = ', rf(119).raku;
