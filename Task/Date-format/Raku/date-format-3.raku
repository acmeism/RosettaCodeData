my @months = <January February March April May June July
              August September October November December>;
my @days = <Monday Tuesday Wednesday Thursday Friday Saturday Sunday>;
my $us-long = sub ($self) { "{@days[$self.day-of-week - 1]}, {@months[$self.month - 1]} {$self.day}, {$self.year}" };
my $d = Date.today :formatter($us-long);

say $d.yyyy-mm-dd; # still works
say $d; # uses our formatter sub
