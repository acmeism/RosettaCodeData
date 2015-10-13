constant DIE = 1..6;

sub MAIN (Int :$players = 2, Int :$goal = 100) {
    my @safe = 0 xx $players;
    for |^$players xx * -> $player {
	say "\nOK, player #$player is up now.";
	my $safe = @safe[$player];
	my $ante = 0;
	until $safe + $ante >= $goal or
	    prompt("#$player, you have $safe + $ante = {$safe+$ante}. Roll? [Yn] ") ~~ /:i ^n/
	{
	    given DIE.roll {
		say "  You rolled a $_.";
		when 1 {
		    say "  Bust!  You lose $ante but keep your previous $safe.";
		    $ante = 0;
		    last;
		}
		when 2..* {
		    $ante += $_;
		}
	    }
	}
	$safe += $ante;
	if $safe >= $goal {
	    say "\nPlayer #$player wins with a score of $safe!";
	    last;
	}
	@safe[$player] = $safe;
	say "  Sticking with $safe." if $ante;
    }
}
