use Inline::Perl5;
my $p5 = Inline::Perl5.new();
$p5.use( 'ntheory' );

sub prime-factors ($i) {
    my &primes = $p5.run('sub { map { ntheory::todigitstring $_ } sort {$a <=> $b} ntheory::factor $_[0] }');
    primes("$i");
}

for 2²⁹-1, 2⁴¹-1, 2⁵⁹-1, 2⁷¹-1, 2⁷⁹-1, 2⁹⁷-1, 2¹¹⁷-1,
5465610891074107968111136514192945634873647594456118359804135903459867604844945580205745718497
 ->  $n {
    my $start = now;
    say "factors of $n: ",
    prime-factors($n).join(' × '), " \t in ", (now - $start).fmt("%0.3f"), " sec."
}
