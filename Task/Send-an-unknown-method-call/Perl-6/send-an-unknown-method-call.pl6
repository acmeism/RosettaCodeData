my $object = 42 but role { method add-me($x) { self + $x } }
my $name = 'add-me';
say $object."$name"(5);  # 47
