sub function { 2 * $^x + 3 };
my @array = 1 .. 5;

# via map function
.say for map &function, @array;

# via map method
.say for @array.map(&function);

# via for loop
for @array {
    say function($_);
}

# via the "hyper" metaoperator and method indirection
say @array».&function;

# we neither need a variable for the array nor for the function
say [1,2,3]>>.&({ $^x + 1});
