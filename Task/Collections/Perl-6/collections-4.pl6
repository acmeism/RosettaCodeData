class Something { has $.foo; has $.bar };
my $obj = Something.new: foo => 1, bar => 2;
my $newobj = $obj but role { has $.baz = 3 } # anonymous mixin
