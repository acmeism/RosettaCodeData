shell "tput cub1";                  # one position to the left
shell "tput cuf1";                  # one position to the right
shell "tput cuu1";                  # up one line
shell "tput cud1";                  # down one line
shell "tput cr";                    # beginning of line
shell "tput home";                  # top left corner

$_ = qx[stty -a </dev/tty 2>&1];
my $rows = +m/'rows '    <(\d+)>/;
my $cols = +m/'columns ' <(\d+)>/;

shell "tput hpa $cols";             # end of line
shell "tput cup $rows $cols";       # bottom right corner
