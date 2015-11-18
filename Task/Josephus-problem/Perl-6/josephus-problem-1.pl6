sub Execute(@prisoner, $k) {
    until @prisoner == 1 {
	@prisoner.=rotate($k - 1);
	@prisoner.shift;
    }
}

my @prisoner = ^41;
Execute @prisoner, 3;
say "Prisoner {@prisoner} survived.";
