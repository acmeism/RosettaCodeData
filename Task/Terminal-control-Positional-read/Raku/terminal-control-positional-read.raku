use NCurses;

# Reference:
# https://github.com/azawawi/perl6-ncurses

# Initialize curses window
my $win = initscr() or die "Failed to initialize ncurses\n";

# Print random text in a 10x10 grid

for ^10 { mvaddstr($_ , 0, (for ^10 {(41 .. 90).roll.chr}).join )};

# Read

my $icol = 3 - 1;
my $irow = 6 - 1;

my $ch = mvinch($irow,$icol);

# Show result

mvaddstr($irow, $icol+10, 'Character at column 3, row 6 = ' ~ $ch.chr);

mvaddstr( LINES() - 2, 2, "Press any key to exit..." );

# Refresh (this is needed)
nc_refresh;

# Wait for a keypress
getch;

# Cleanup
LEAVE {
    delwin($win) if $win;
    endwin;
}
