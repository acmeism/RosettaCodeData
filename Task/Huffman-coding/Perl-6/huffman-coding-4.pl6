my $original = 'this is an example for huffman encoding';

my %encode-key = huffman $original.comb.Bag;
my %decode-key = %encode-key.invert;
my @codes      = %decode-key.keys;

my $encoded = $original.subst: /./,      { %encode-key{$_} }, :g;
my $decoded = $encoded .subst: /@codes/, { %decode-key{$_} }, :g;

.say for $original, $encoded, $decoded;
