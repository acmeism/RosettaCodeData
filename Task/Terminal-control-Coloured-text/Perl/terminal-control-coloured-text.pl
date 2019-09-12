my %colors = (
    red     => "\e[1;31m",
    green   => "\e[1;32m",
    yellow  => "\e[1;33m",
    blue    => "\e[1;34m",
    magenta => "\e[1;35m",
    cyan    => "\e[1;36m"
);
$clr = "\e[0m";

print "$colors{$_}$_ text $clr\n" for sort keys %colors;

# the Perl 6 code also works
use feature 'say';
use Term::ANSIColor;

say colored('RED ON WHITE', 'bold red on_white');
say colored('GREEN', 'bold green');
say colored('BLUE ON YELLOW', 'bold blue on_yellow');
say colored('MAGENTA', 'bold magenta');
say colored('CYAN ON RED', 'bold cyan on_red');
say colored('YELLOW', 'bold yellow');
