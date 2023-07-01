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
constant ansi = True; # color!

my @board = ( ['' xx n] xx n );
my $save  = '';
my $score = 0;

constant $top = join '─' x cell, '┌', '┬' xx n-1, '┐';
constant $mid = join '─' x cell, '├', '┼' xx n-1, '┤';
constant $bot = join '─' x cell, '└', '┴' xx n-1, '┘';

my %dir = (
   "\e[A" => 'up',
   "\e[B" => 'down',
   "\e[C" => 'right',
   "\e[D" => 'left',
);

my @ANSI = <0 1;97 1;93 1;92 1;96 1;91 1;95 1;94 1;30;47 1;43
    1;42 1;46 1;41 1;45 1;44 1;33;43 1;33;42 1;33;41 1;33;44>;

sub row (@row) { '│' ~ (join '│', @row».&center) ~ '│' }

sub center ($s){
    my $c   = cell - $s.chars;
    my $pad = ' ' x ceiling($c/2);
    my $tile = sprintf "%{cell}s", "$s$pad";
    my $idx = $s ?? $s.log(2) !! 0;
    ansi ?? "\e[{@ANSI[$idx]}m$tile\e[0m" !! $tile;
}

sub draw-board {
    run('clear');
    print qq:to/END/;


	Press direction arrows to move.

	Press q to quit.

	$top
	{ join "\n\t$mid\n\t", map { .&row }, @board }
	$bot

	Score: $score

END
}

sub squash (@c) {
    my @t = grep { .chars }, @c;
    map { combine(@t[$_], @t[$_+1]) if @t[$_] && @t[$_+1] == @t[$_] }, ^@t-1;
    @t = grep { .chars }, @t;
    @t.push: '' while @t < n;
    @t;
}

sub combine ($v is rw, $w is rw) { $v += $w; $w = ''; $score += $v; }

proto sub move (|) {*};

multi move('up') {
    map { @board[*;$_] = squash @board[*;$_] }, ^n;
}

multi move('down') {
    map { @board[*;$_] = reverse squash reverse @board[*;$_] }, ^n;
}

multi move('left') {
    map { @board[$_] = squash @board[$_] }, ^n;
}

multi move('right') {
    map { @board[$_;*] = reverse squash reverse @board[$_] }, ^n;
}

sub another {
    my @empties;
    for @board.kv -> $r, @row {
        @empties.push(($r, $_)) for @row.grep(:k, '');
    }
    my ( $x, $y ) = @empties.roll;
    @board[$x; $y] = (flat 2 xx 9, 4).roll;
}

sub save () { join '|', flat @board».list }

loop {
    another if $save ne save();
    draw-board;
    $save = save();

    # Read up to 4 bytes from keyboard buffer.
    # Page navigation keys are 3-4 bytes each.
    # Specifically, arrow keys are 3.
    my $key = $*IN.read(4).decode;

    move %dir{$key} if so %dir{$key};
    last if $key eq 'q'; # (q)uit
}
