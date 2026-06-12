use 5.020;
use ntheory qw(is_square_free);
use experimental qw(signatures);
use Math::AnyNum qw(:overload idiv iroot ipow is_coprime);

sub powerful_numbers ($n, $k = 2) {

    my @powerful;

    sub ($m, $r) {
        if ($r < $k) {
            push @powerful, $m;
            return;
        }
        for my $v (1 .. iroot(idiv($n, $m), $r)) {
            if ($r > $k) {
                is_square_free($v) || next;
                is_coprime($m, $v) || next;
            }
            __SUB__->($m * ipow($v, $r), $r - 1);
        }
    }->(1, 2*$k - 1);

    sort { $a <=> $b } @powerful;
}

foreach my $k (2 .. 10) {
    my @a = powerful_numbers(10**$k, $k);
    my $h = join(', ', @a[0..4]);
    my $t = join(', ', @a[$#a-4..$#a]);
    printf("For k=%-2d there are %d k-powerful numbers <= 10^k: [%s, ..., %s]\n", $k, scalar(@a), $h, $t);
}
