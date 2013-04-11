sub fs ( Code $f, @s ) { @s.map: { .$f } }

sub f1 ( $n ) { $n *  2 }
sub f2 ( $n ) { $n ** 2 }

my &fsf1 := &fs.assuming: f => &f1;
my &fsf2 := &fs.assuming: f => &f2;

for [1..3], [2, *+2 ... 8] X &fsf1, &fsf2 -> $s, $f {
    say ~ $f.($s);
}
