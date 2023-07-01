# The Task #
my @firstSet  = «the that a»;
my @secondSet = «frog elephant thing»;
my @thirdSet  = «walked treaded grows»;
my @fourthSet = «slowly quickly»;

.say for doAmb [@firstSet, @secondSet, @thirdSet, @fourthSet];


sub doAmb( @lol ) {	# Takes out the correct sentences.
	my @sentences = map *.join(" "), [X] @lol;
	grep &isAmb, @sentences;
}

sub isAmb( $sentence ) {	# Checks `$sentence` for correctness.
	$sentence !~~ / (.) " " (.)	<!{$0 eq $1}> /	# <https://docs.raku.org/language/regexes#Regex_boolean_condition_check>
}
