system "tput cub1"; sleep 1;  # one position to the left
system "tput cuf1"; sleep 1;  # one position to the right
system "tput cuu1"; sleep 1;  # up one line
system "tput cud1"; sleep 1;  # down one line
system "tput cr";   sleep 1;  # beginning of line
system "tput home"; sleep 1;  # top left corner

$_ = qx[stty -a </dev/tty 2>&1];
my($rows,$cols) = /(\d+) rows; (\d+) col/;
$rows--; $cols--;

system "tput cup $rows $cols"; # bottom right corner
sleep 1;
