class Thing {
  method regular-example() { say 'I haz a method' }

  multi method multi-example() { say 'No arguments given' }
  multi method multi-example(Str $foo) { say 'String given' }
  multi method multi-example(Int $foo) { say 'Integer given' }
};

# 'new' is actually a method, not a special keyword:
my $thing = Thing.new;

# No arguments: parentheses are optional
$thing.regular-example;
$thing.regular-example();
$thing.multi-example;
$thing.multi-example();

# Arguments: parentheses or colon required
$thing.multi-example("This is a string");
$thing.multi-example: "This is a string";
$thing.multi-example(42);
$thing.multi-example: 42;

# Indirect (reverse order) method call syntax: colon required
my $foo = new Thing: ;
multi-example $thing: 42;
