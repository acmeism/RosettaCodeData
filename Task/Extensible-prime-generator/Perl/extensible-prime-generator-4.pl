use bigint;
use Math::Prime::Util qw/forprimes prime_get_config/;
warn "No GMP, expect slow results\n" unless prime_get_config->{gmp};
my $n = 10**200;
forprimes { say $_-$n } $n,$n+1000;
