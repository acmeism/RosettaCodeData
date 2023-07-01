class PCG32 {
    has $!state;
    has $!incr;
    constant mask32 = 2³² - 1;
    constant mask64 = 2⁶⁴ - 1;
    constant const = 6364136223846793005;

    submethod BUILD (
        Int :$seed = 0x853c49e6748fea9b, # default seed
        Int :$incr = 0xda3e39cb94b95bdb  # default increment
      ) {
        $!incr  = $incr +< 1 +| 1 +& mask64;
        $!state = (($!incr + $seed) * const + $!incr) +& mask64;
    }

    method next-int {
        my $shift  = ($!state +> 18 +^ $!state) +> 27 +& mask32;
        my $rotate =  $!state +> 59 +& 31;
        $!state    = ($!state * const + $!incr) +& mask64;
        ($shift +> $rotate) +| ($shift +< (32 - $rotate) +& mask32)
    }

    method next-rat { self.next-int / 2³² }
}


# Test next-int with custom seed and increment
say 'Seed: 42, Increment: 54; first five Int values:';
my $rng = PCG32.new( :seed(42), :incr(54) );
.say for $rng.next-int xx 5;


# Test next-rat (since these are rational numbers by default)
say "\nSeed: 987654321, Increment: 1; first 1e5 Rat values histogram:";
$rng = PCG32.new( :seed(987654321), :incr(1) );
say ( ($rng.next-rat * 5).floor xx 100_000 ).Bag;


# Test next-int with default seed and increment
say "\nSeed: default, Increment: default; first five Int values:";
$rng = PCG32.new;
.say for $rng.next-int xx 5;
