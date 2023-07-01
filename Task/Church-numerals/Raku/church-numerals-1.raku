constant $zero  = sub (Code $f) {
                  sub (     $x) { $x }}

constant $succ  = sub (Code $n) {
                  sub (Code $f) {
                  sub (     $x) { $f($n($f)($x)) }}}

constant $add   = sub (Code $n) {
                  sub (Code $m) {
                  sub (Code $f) {
                  sub (     $x) { $m($f)($n($f)($x)) }}}}

constant $mult  = sub (Code $n) {
                  sub (Code $m) {
                  sub (Code $f) {
                  sub (     $x) { $m($n($f))($x) }}}}

constant $power = sub (Code $b) {
                  sub (Code $e) { $e($b) }}

sub to_int (Code $f) {
    sub countup (Int $i) { $i + 1 }
    return $f(&countup).(0)
}

sub from_int (Int $x) {
    multi sub countdown (     0) { $zero }
    multi sub countdown (Int $i) { $succ( countdown($i - 1) ) }
    return countdown($x);
}

constant $three = $succ($succ($succ($zero)));
constant $four  = from_int(4);

say map &to_int,
    $add(   $three )( $four  ),
    $mult(  $three )( $four  ),
    $power( $four  )( $three ),
    $power( $three )( $four  ),
;
