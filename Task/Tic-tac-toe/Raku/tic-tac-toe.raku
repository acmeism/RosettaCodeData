my @board = 1..9;
my @winning-positions = [0..2], [3..5], [6..8], [0,3,6], [1,4,7], [2,5,8],
	[0,4,8], [6,4,2];

sub get-winner() {
	for @winning-positions {
        return (@board[|$_][0], $_) if [eq] @board[|$_];
	}
}

sub free-indexes() {
	@board.keys.grep: { @board[$_] eq any(1..9) }
}

sub ai-move() {
	given free-indexes.pick {
		@board[$_] = 'o';
		say "I go at: { $_ + 1 }\n";
	}
}

sub print-board() {
    print "\e[2J";
    say @board.map({ "$^a | $^b | $^c" }).join("\n--+---+--\n"), "\n";
}

sub human-move() {
	my $pos = prompt "Choose one of { (free-indexes() »+» 1).join(",") }: ";
	if $pos eq any(free-indexes() »+» 1) {
		@board[$pos - 1] = 'x';
	} else {
		say "Sorry, you want to put your 'x' where?";
		human-move();
	}
}

for flat (&ai-move, &human-move) xx * {
	print-board;
    last if get-winner() or not free-indexes;
    .();
}

if get-winner() -> ($player, $across) {
	say "$player wins across [", ($across »+» 1).join(", "), "].";
} else {
	say "How boring, a draw!";
}
