# 20200917 added Perl programming solution

use strict;
use warnings;

use Curses;

initscr or die;

my $win = Curses->new;

foreach my $row (0..9) {
   $win->addstr( $row , 0, join('', map { chr(int(rand(50)) + 41) } (0..9)))
};

my $icol = 3 - 1;
my $irow = 6 - 1;

my $ch = $win->inch($irow,$icol);

$win->addstr( $irow, $icol+10, 'Character at column 3, row 6 = '.$ch );

$win->addstr( LINES() - 2, 2, "Press any key to exit..." );

$win->getch;

endwin;
