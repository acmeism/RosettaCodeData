# we use the [] reduction meta operator along with the Cartesian Product
# operator X to create the Cartesian Product of four times [1..9] and then get
# all the elements where the number of unique digits is four.
my @candidates = ([X] [1..9] xx 4).tree.grep: *.uniq == 4;

repeat {
	my $guess = @candidates.pick;
	my ($bulls, $cows) = read-score;
	@candidates .= grep: &score-correct;

	# note how we declare our two subroutines within the repeat block. This
	# limits the scope in which the routines are known to the scope in which
	# they are needed and saves us a lot of arguments to our two routines.
	sub score-correct($a) {
		# use the Z (zip) meta operator along with == to construct the
		# list ($a[0] == $b[0], $a[1] == $b[1], ...) and then add it up
		# using the reduction meta operator [] and +.
		my $exact = [+] $a Z== $guess;

		# number of elements of $a that match any element of $b
		my $loose = +$a.grep: any @$guess;

		return $bulls == $exact && $cows == $loose - $exact;
	}

	sub read-score() {
		loop {
			my $score = prompt "My guess: {$guess.join}.\n";

			# use the :s modifier to tell Perl 6 to handle spaces
			# automatically and save the first digit in $<bulls> and
			# the second digit in $<cows>
			if $score ~~ m:s/^ $<bulls>=(\d) $<cows>=(\d) $/
				and $<bulls> + $<cows> <= 4 {
				return +$<bulls>, +$<cows>;
			}

			say "Please specify the number of bulls and cows";
		}
	}
} while @candidates > 1;

say @candidates
	?? "Your secret number is {@candidates[0].join}!"
	!! "I think you made a mistake with your scoring.";
