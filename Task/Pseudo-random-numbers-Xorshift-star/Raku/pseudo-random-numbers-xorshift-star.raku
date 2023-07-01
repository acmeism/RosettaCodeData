class Xorshift-star {
    has $!state;

    submethod BUILD ( Int :$seed where * > 0 = 1 ) { $!state = $seed }

    method next-int {
        $!state +^= $!state +> 12;
        $!state +^= $!state +< 25 +& (2⁶⁴ - 1);
        $!state +^= $!state +> 27;
        ($!state * 0x2545F4914F6CDD1D) +> 32 +& (2³² - 1)
    }

    method next-rat { self.next-int / 2³² }
}

# Test next-int
say 'Seed: 1234567; first five Int values';
my $rng = Xorshift-star.new( :seed(1234567) );
.say for $rng.next-int xx 5;


# Test next-rat (since these are rational numbers by default)
say "\nSeed: 987654321; first 1e5 Rat values histogram";
$rng = Xorshift-star.new( :seed(987654321) );
say ( ($rng.next-rat * 5).floor xx 100_000 ).Bag;


# Test with default seed
say "\nSeed: default; first five Int values";
$rng = Xorshift-star.new;
.say for $rng.next-int xx 5;
