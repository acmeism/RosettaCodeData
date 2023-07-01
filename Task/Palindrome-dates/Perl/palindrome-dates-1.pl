use Time::Piece;
my $d = Time::Piece->strptime("2020-02-02", "%Y-%m-%d");

for (my $k = 1 ; $k <= 15 ; $d += Time::Piece::ONE_DAY) {
    my $s = $d->strftime("%Y%m%d");
    if ($s eq reverse($s) and ++$k) {
        print $d->strftime("%Y-%m-%d\n");
    }
}
