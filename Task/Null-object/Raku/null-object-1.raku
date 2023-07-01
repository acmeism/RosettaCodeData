my $var;
say $var.WHAT;      # Any()
$var = 42;
say $var.WHAT;      # Int()
say $var.defined;   # True
$var = Nil;
say $var.WHAT;      # Any()
say $var.defined    # False
