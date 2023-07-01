class splitmix64 {
    has $!state;

    submethod BUILD ( Int :$seed where * >= 0 = 1 ) { $!state = $seed }

    method next-int {
        my $next = $!state = ($!state + 0x9e3779b97f4a7c15) +& (2⁶⁴ - 1);
        $next = ($next +^ ($next +> 30)) * 0xbf58476d1ce4e5b9 +& (2⁶⁴ - 1);
        $next = ($next +^ ($next +> 27)) * 0x94d049bb133111eb +& (2⁶⁴ - 1);
        ($next +^ ($next +> 31)) +& (2⁶⁴ - 1);
    }

    method next-rat { self.next-int / 2⁶⁴ }
}

# Test next-int
say 'Seed: 1234567; first five Int values';
my $rng = splitmix64.new( :seed(1234567) );
.say for $rng.next-int xx 5;


# Test next-rat (since these are rational numbers by default)
say "\nSeed: 987654321; first 1e5 Rat values histogram";
$rng = splitmix64.new( :seed(987654321) );
say ( ($rng.next-rat * 5).floor xx 100_000 ).Bag;
