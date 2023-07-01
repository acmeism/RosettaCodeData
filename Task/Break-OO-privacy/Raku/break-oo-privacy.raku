class Foo {
    has $!shyguy = 42;
}
my Foo $foo .= new;

say $foo.^attributes.first('$!shyguy').get_value($foo);
