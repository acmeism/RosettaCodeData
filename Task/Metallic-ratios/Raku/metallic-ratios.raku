use Rat::Precise;
use Lingua::EN::Numbers;

sub lucas ($b) { 1, 1, * + $b * * … * }

sub metallic ($seq, $places = 32) {
    my $n = 0;
    my $last = 0;
    loop {
        my $approx = FatRat.new($seq[$n + 1], $seq[$n]);
        my $this = $approx.precise($places, :z);
        last if $this eq $last;
        $last = $this;
        $n++;
    }
    $last, $n
}

sub display ($value, $n) {
    "Approximated value:", $value, "Reached after {$n} iterations: " ~
    "{ordinal-digit $n}/{ordinal-digit $n - 1} element."
}

for <Platinum Golden Silver Bronze Copper Nickel Aluminum Iron Tin Lead>.kv
  -> \b, $name {
    my $lucas = lucas b;
    print "\nLucas sequence for $name ratio; where b = {b}:\nFirst 15 elements: ";
    say join ', ', $lucas[^15];
    say join ' ', display |metallic($lucas);
}

# Stretch goal
say join "\n", "\nGolden ratio to 256 decimal places:", display |metallic lucas(1), 256;
