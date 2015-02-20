sub noargs(); # Declare a function with no arguments
sub twoargs($$); # Declare a function with two scalar arguments. The two sigils act as argument type placeholders
sub noargs :prototype(); # Using the :attribute syntax instead
sub twoargs :prototype($$);
