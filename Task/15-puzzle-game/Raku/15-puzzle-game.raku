use Term::termios;

constant $saved   = Term::termios.new(fd => 1).getattr;
constant $termios = Term::termios.new(fd => 1).getattr;
# raw mode interferes with carriage returns, so
# set flags needed to emulate it manually
$termios.unset_iflags(<BRKINT ICRNL ISTRIP IXON>);
$termios.unset_lflags(< ECHO ICANON IEXTEN ISIG>);
$termios.setattr(:DRAIN);

# reset terminal to original setting on exit
END { $saved.setattr(:NOW) }

constant n    = 4; # board size
constant cell = 6; # cell width

constant $top = join '─' x cell, '┌', '┬' xx n-1, '┐';
constant $mid = join '─' x cell, '├', '┼' xx n-1, '┤';
constant $bot = join '─' x cell, '└', '┴' xx n-1, '┘';

my %dir = (
   "\e[A" => 'up',
   "\e[B" => 'down',
   "\e[C" => 'right',
   "\e[D" => 'left',
);

my @solved = [1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,' '];
my @board;
new();

sub new () {
    loop {
       @board = shuffle();
       last if parity-ok(@board);
   }
}

sub parity-ok (@b) {
    my $row = @b.first(/' '/,:k);
    my $col = @b[$row].first(/' '/,:k);
    so ([3,3] <<->> [$row,$col]).sum %% 2;
}

sub shuffle () {
    my @c = [1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,' '];
    for (^16).pick(*) -> $y, $x {
        my ($yd, $ym, $xd, $xm) = ($y div n, $y mod n, $x div n, $x mod n);
        @(@c[$ym;$yd],@c[$xm;$xd]) = @(@c[$xm;$xd],@c[$ym;$yd]);
    }
    @c;
}

sub row (@row) { '│' ~ (join '│', @row».&center) ~ '│' }

sub center ($s){
    my $c   = cell - $s.chars;
    my $pad = ' ' x ceiling($c/2);
    sprintf "%{cell}s", "$s$pad";
}

sub draw-board {
    run('clear');
    print qq:to/END/;


	Press direction arrows to move.

	Press q to quit. Press n for a new puzzle.

	$top
	{ join "\n\t$mid\n\t", map { .&row }, @board }
	$bot

	{ (so @board ~~ @solved) ?? 'Solved!!' !! '' }
END
}

sub slide (@c is copy) {
    my $t = (grep { /' '/ }, :k, @c)[0];
    return @c unless $t and $t > 0;
    @c[$t,$t-1] = @c[$t-1,$t];
    @c;
}

proto sub move (|) {*};

multi move('up') {
    map { @board[*;$_] = reverse slide reverse @board[*;$_] }, ^n;
}

multi move('down') {
    map { @board[*;$_] = slide @board[*;$_] }, ^n;
}

multi move('left') {
    map { @board[$_] = reverse slide reverse @board[$_] }, ^n;
}

multi move('right') {
    map { @board[$_] = slide @board[$_] }, ^n;
}

loop {
    draw-board;

    # Read up to 4 bytes from keyboard buffer.
    # Page navigation keys are 3-4 bytes each.
    # Specifically, arrow keys are 3.
    my $key = $*IN.read(4).decode;

    move %dir{$key} if so %dir{$key};
    last if $key eq 'q'; # (q)uit
    new() if $key eq 'n';
}
