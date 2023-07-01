class Bar { }             # an empty class

my $object = Bar.new;     # new instance

role a_role {             # role to add a variable: foo,
   has $.foo is rw = 2;   # with an initial value of 2
}

$object does a_role;      # compose in the role

say $object.foo;          # prints: 2
$object.foo = 5;          # change the variable
say $object.foo;          # prints: 5

my $ohno = Bar.new;       # new Bar object
#say $ohno.foo;           # runtime error, base Bar class doesn't have the variable foo

my $this = $object.new;   # instantiate a new Bar derived from $object
say $this.foo;            # prints: 2 - original role value

my $that = $object.clone; # instantiate a new Bar derived from $object copying any variables
say $that.foo;            # 5 - value from the cloned object
