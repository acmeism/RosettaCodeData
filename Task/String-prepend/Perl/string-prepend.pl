use strict;
use warnings;
use feature ':all';

# explicit concatentation
$_ = 'bar';
$_ = 'Foo' . $_;
say;


# lvalue substr
$_ = 'bar';
substr $_, 0, 0, 'Foo';
say;


# interpolation as concatenation
# (NOT safe if concatenate sigils)
$_ = 'bar';
$_ = "Foo$_";
say;
