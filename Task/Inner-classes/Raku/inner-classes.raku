class Outer {
    has $.value is rw;
    method double { self.value ×= 2 }

    class Inner {
        has $.value is rw;
    }
}

# New Outer instance with a value of 42.
my $outer = Outer.new(:value(42));

say .^name, ' ', .value given $outer;
$outer.double;
say .^name, ' ', .value given $outer;

# New Inner instance with no value set. Note need to specify fully qualified name.
my $inner = Outer::Inner.new;

# Set a value after the fact.
$inner.value = 16;

# There is no way for the Inner object to call the Outer .double method.
# It is a separate, distinct class, just in a funny namespace.
say .^name, ' ', .value given $inner;
$inner.value /=2;
say .^name, ' ', .value given $inner;
