use 5.020;
use warnings;
use experimental qw(signatures);

use ntheory qw(fromdigits todigitstring);

sub generate_esthetic ($root, $upto, $callback, $base = 10) {

    my $v = fromdigits($root, $base);

    return if ($v > $upto);
    $callback->($v);

    my $t = $root->[-1];

    __SUB__->([@$root, $t + 1], $upto, $callback, $base) if ($t + 1 < $base);
    __SUB__->([@$root, $t - 1], $upto, $callback, $base) if ($t - 1 >= 0);
}

sub between_esthetic ($from, $upto, $base = 10) {
    my @list;
    foreach my $k (1 .. $base - 1) {
        generate_esthetic([$k], $upto,
            sub($n) { push(@list, $n) if ($n >= $from) }, $base);
    }
    sort { $a <=> $b } @list;
}

sub first_n_esthetic ($n, $base = 10) {
    for (my $m = $n * $n ; 1 ; $m *= $base) {
        my @list = between_esthetic(1, $m, $base);
        return @list[0 .. $n - 1] if @list >= $n;
    }
}

foreach my $base (2 .. 16) {
    say "\n$base-esthetic numbers at indices ${\(4*$base)}..${\(6*$base)}:";
    my @list = first_n_esthetic(6 * $base, $base);
    say join(' ', map { todigitstring($_, $base) } @list[4*$base-1 .. $#list]);
}

say "\nBase 10 esthetic numbers between 1,000 and 9,999:";
for (my @list = between_esthetic(1e3, 1e4) ; @list ;) {
    say join(' ', splice(@list, 0, 20));
}

say "\nBase 10 esthetic numbers between 100,000,000 and 130,000,000:";
for (my @list = between_esthetic(1e8, 1.3e8) ; @list ;) {
    say join(' ', splice(@list, 0, 9));
}
