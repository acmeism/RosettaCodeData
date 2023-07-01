sub R {
    my ($n, $p) = @_;
    my $r = join '',
    map { rand() < $p ? 1 : 0 } 1 .. $n;
    0+ $r =~ s/1+//g;
}

use constant t => 100;

printf "t= %d\n", t;
for my $p (qw(.1 .3 .5 .7 .9)) {
    printf "p= %f, K(p)= %f\n", $p, $p*(1-$p);
    for my $n (qw(10 100 1000)) {
        my $r; $r += R($n, $p) for 1 .. t; $r /= $n;
        printf " R(n, p)= %f\n", $r / t;
    }
}
