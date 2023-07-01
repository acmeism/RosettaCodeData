class MRG32k3a {
    has @!x1;
    has @!x2;

    constant a1 = 0, 1403580, -810728;
    constant a2 = 527612, 0, -1370589;
    constant m1 = 2**32 - 209;
    constant m2 = 2**32 - 22853;

    submethod BUILD ( Int :$seed where 0 < * <= m1 = 1 ) { @!x1 = @!x2 = $seed, 0, 0 }

    method next-int {
        @!x1.unshift: (a1[0] * @!x1[0] + a1[1] * @!x1[1] + a1[2] * @!x1[2]) % m1; @!x1.pop;
        @!x2.unshift: (a2[0] * @!x2[0] + a2[1] * @!x2[1] + a2[2] * @!x2[2]) % m2; @!x2.pop;
        (@!x1[0] - @!x2[0]) % (m1 + 1)
    }

    method next-rat { self.next-int / (m1 + 1) }
}


# Test next-int with custom seed
say 'Seed: 1234567; first five Int values:';
my $rng = MRG32k3a.new :seed(1234567);
.say for $rng.next-int xx 5;


# Test next-rat (since these are rational numbers by default)
say "\nSeed: 987654321; first 1e5 Rat values histogram:";
$rng = MRG32k3a.new :seed(987654321);
say ( ($rng.next-rat * 5).floor xx 100_000 ).Bag;


# Test next-int with default seed
say "\nSeed: default; first five Int values:";
$rng = MRG32k3a.new;
.say for $rng.next-int xx 5;
