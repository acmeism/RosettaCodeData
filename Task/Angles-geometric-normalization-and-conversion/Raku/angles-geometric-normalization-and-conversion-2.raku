sub postfix:<t>( $t ) { my $a = $t % 1 * τ;           $t >=0 ?? $a !! $a - τ }
sub postfix:<d>( $d ) { my $a = $d % 360 * τ / 360;   $d >=0 ?? $a !! $a - τ }
sub postfix:<g>( $g ) { my $a = $g % 400 * τ / 400;   $g >=0 ?? $a !! $a - τ }
sub postfix:<m>( $m ) { my $a = $m % 6400 * τ / 6400; $m >=0 ?? $a !! $a - τ }
sub postfix:<r>( $r ) { my $a = $r % τ;               $r >=0 ?? $a !! $a - τ }

sub postfix:«->t» ($angle) { my $a = $angle / τ;        ($angle < 0 and $a == -1)    ?? -0 !! $a }
sub postfix:«->d» ($angle) { my $a = $angle / τ * 360;  ($angle < 0 and $a == -360)  ?? -0 !! $a }
sub postfix:«->g» ($angle) { my $a = $angle / τ * 400;  ($angle < 0 and $a == -400)  ?? -0 !! $a }
sub postfix:«->m» ($angle) { my $a = $angle / τ * 6400; ($angle < 0 and $a == -6400) ?? -0 !! $a }
sub postfix:«->r» ($angle) { my $a = $angle;            ($angle < 0 and $a == -τ)    ?? -0 !! $a }

for <-2 -1 0 1 2 6.2831853 16 57.2957795 359 399 6399 1000000> -> $a {
    say '';
    say '  Quantity  Unit      ', <turns degrees gradians mils radians>.fmt('%15s');
    for 'turns', &postfix:«t», 'degrees', &postfix:«d», 'gradians', &postfix:«g»,
        'mils',  &postfix:«m», 'radians', &postfix:«r»
      -> $unit, &f {
            printf "%10s %-10s %15s %15s %15s %15s %15s\n", $a, $unit,
            |($a.&f->t, $a.&f->d, $a.&f->g, $a.&f->m, $a.&f->r)».round(.00000001);
    }
}
