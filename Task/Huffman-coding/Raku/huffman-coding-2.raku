sub huffman (%frequencies) {
    my @queue = %frequencies.map: { .value => (hash .key => '') };
    while @queue > 1 {
        @queue.=sort;
        my $x = @queue.shift;
        my $y = @queue.shift;
        @queue.push: ($x.key + $y.key) => hash $x.value.deepmap('0' ~ *),
                                               $y.value.deepmap('1' ~ *);
    }
    @queue[0].value;
}

# Testing

for huffman 'this is an example for huffman encoding'.comb.Bag {
    say "'{.key}' : {.value}";
}

# To demonstrate that the table can do a round trip:

say '';
my $original = 'this is an example for huffman encoding';

my %encode-key = huffman $original.comb.Bag;
my %decode-key = %encode-key.invert;
my @codes      = %decode-key.keys;

my $encoded = $original.subst: /./,      { %encode-key{$_} }, :g;
my $decoded = $encoded .subst: /@codes/, { %decode-key{$_} }, :g;

.say for $original, $encoded, $decoded;
