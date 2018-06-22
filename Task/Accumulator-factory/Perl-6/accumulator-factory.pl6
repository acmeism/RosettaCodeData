sub accum ($n is copy) { sub { $n += $^x } }

#Example use:
my $a = accum 5;
$a(4.5);
say $a(.5);   # Prints "10".

# You can also use the "&" sigil to create a function that behaves syntactically
# like any other function (i.e. no sigil nor parentheses needed to call it):

my &b = accum 5;
say b 3;   # Prints "8".
