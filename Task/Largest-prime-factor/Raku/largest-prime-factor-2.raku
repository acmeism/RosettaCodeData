use Inline::Perl5;
my $p5 = Inline::Perl5.new();
$p5.use: 'ntheory';
my &lpf = $p5.run('sub { ntheory::todigitstring ntheory::vecmax ntheory::factor $_[0] }');

my $start = now;

for flat 600851475143, (1..∞).map: { 2 +< $_ - 1 } {
    say "Largest prime factor of $_: ", lpf "$_";
    last if now - $start > 1; # quit after one second of total run time
}
