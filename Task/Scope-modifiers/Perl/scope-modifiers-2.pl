package Foo;
my $fruit = 'apple';
package Bar;
print "$fruit\n";         # Prints "apple".
{
    my $fruit = 'banana';
    print "$fruit\n";     # Prints "banana".
}
print "$fruit\n";         # Prints "apple".
                          # The second $fruit has been destroyed.
our $fruit = 'orange';
print "$fruit\n";         # Prints "orange"; refers to $Bar::fruit.
                          # The first $fruit is inaccessible.
