sub encode ( Str $word ) {
    my @sym = 'a' .. 'z';
    gather for $word.comb -> $c {
	die "Symbol '$c' not found in @sym" if $c eq @sym.none;
        @sym[0 .. take (Nil, @sym ... $c).end] .= rotate(-1);
    }
}

sub decode ( @enc ) {
    my @sym = 'a' .. 'z';
    [~] gather for @enc -> $pos {
        take @sym[$pos];
        @sym[0..$pos] .= rotate(-1);
    }
}

use Test;
plan 3;
for <broood bananaaa hiphophiphop> -> $word {
    my $enc = encode($word);
    my $dec = decode($enc);
    is $word, $dec, "$word.fmt('%-12s') ($enc[])";
}
