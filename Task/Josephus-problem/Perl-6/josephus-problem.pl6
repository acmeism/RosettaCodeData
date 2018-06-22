sub Execute(@prisoner, $k) {
    until @prisoner == 1 {
	@prisoner.=rotate($k - 1);
	@prisoner.shift;
    }
}

my @prisoner = ^41;
Execute @prisoner, 3;
say "Prisoner {@prisoner} survived.";

# We don't have to use numbers.  Any list will do:

my @dalton = <Joe Jack William Averell Rantanplan>;
Execute @dalton, 2;
say "{@dalton} survived.";
