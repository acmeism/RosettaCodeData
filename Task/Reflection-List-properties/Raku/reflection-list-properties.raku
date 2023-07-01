class Foo {
    has $!a = now;
    has Str $.b;
    has Int $.c is rw;
}

my $object = Foo.new: b => "Hello", c => 42;

for $object.^attributes {
    say join ", ", .name, .readonly, .container.^name, .get_value($object);
}
