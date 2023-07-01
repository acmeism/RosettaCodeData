use strict;
$x = 1;                   # Compilation error.
our $y = 2;
print "$y\n";             # Legal; refers to $main::y.

package Foo;
our $z = 3;
package Bar;
print "$z\n";             # Refers to $Foo::z.
