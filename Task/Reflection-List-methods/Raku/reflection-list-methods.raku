class Foo {
    method foo ($x)      { }
    method bar ($x, $y)  { }
    method baz ($x, $y?) { }
}

my $object = Foo.new;

for $object.^methods {
    say join ", ", .name, .arity, .count, .signature.gist
}
