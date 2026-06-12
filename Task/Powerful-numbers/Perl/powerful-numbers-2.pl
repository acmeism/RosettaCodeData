use 5.020;
use ntheory qw(is_square_free);
use experimental qw(signatures);
use Math::AnyNum qw(:overload idiv iroot ipow is_coprime);

sub powerful_count ($n, $k = 2) {

    my $count = 0;

    sub ($m, $r) {
        if ($r <= $k) {
            $count += iroot(idiv($n, $m), $r);
            return;
        }
        for my $v (1 .. iroot(idiv($n, $m), $r)) {
            is_square_free($v) || next;
            is_coprime($m, $v) || next;
            __SUB__->($m * ipow($v, $r), $r - 1);
        }
    }->(1, 2*$k - 1);

    return $count;
}

foreach my $k (2 .. 10) {
    printf("Number of %2d-powerful <= 10^j for 0 <= j < %d: {%s}\n", $k, $k+10,
        join(', ', map { powerful_count(ipow(10, $_), $k) } 0..($k+10-1)));
}
