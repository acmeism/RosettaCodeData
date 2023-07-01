srand 123456; # For repeatability

my @header   = < A D F G V X >;
my $polybius = (flat 'A'..'Z', 0..9).pick(*).join;

my $key-length = 9;
my $key = uc 'unixdict.txt'.IO.words.grep( { (.chars == $key-length) && (+.comb.Set == +.comb) } ).roll;

my %cypher   = (@header X~ @header) Z=> $polybius.comb;

my $message = 'Attack at 1200AM';

use Terminal::Boxer;
say "Key: $key\n";
say "Polybius square:\n", ss-box :7col, :3cw, :indent("\t"), '', |@header, |(@header Z $polybius.comb.batch: 6);
say "Message to encode: $message";
say "\nEncoded: " ~ my $encoded = encode $message;
say "\nDecoded: " ~ decode $encoded;

sub encode ($text is copy) {
    $text = $text.uc.comb(/<[A..Z 0..9]>/).join;
    my @order = $key.comb.pairs.sort( *.value )».key;
    my @encode = %cypher.invert.hash{ $text.comb }.join.comb.batch($key-length).map: { [$_] };
    ((^$key-length).map: { @encode».[@order]».grep( *.defined )».[$_].grep( *.defined ).join }).Str;
}

sub decode ($text is copy) {
    my @text = $text.split(' ')».comb;
    my $chars = @text[0].chars;
    $_ = flat |$_, ' ' if .chars < $chars for @text;
    my @order = $key.comb.pairs.sort( *.value )».key.pairs.sort( *.value )».key;
    %cypher{ ( grep { /\w/ }, flat [Z] @order.map( { |@text.batch($key-length)».[$_] } ) ).batch(2)».join }.join;
}
