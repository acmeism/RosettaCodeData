my $prime-tests = 0;
my @non-primes;
sub spy-prime ($n) {
    $prime-tests++;
    my $is-p = $n.is-prime;

    push @non-primes, $n unless $is-p;
    return $is-p;
}

my @p = <2 3 5 7>;

say gather while @p {
    .take for @p;

    @p = ( @p X~ <3 7> ).grep: { !.ends-with(33|77) and .&spy-prime };
}
.say for :$prime-tests, :@non-primes;
