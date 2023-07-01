use strict;
use warnings;
use Term::ReadKey;

ReadMode 4; # change to raw input mode

sub logger { my($message) = @_; print "$message\n" }

while (1) {
    if (my $c = ReadKey 0) { # read a single character
        if ($c eq 'q') { logger "QUIT"; last }
        elsif ($c =~ /\n|\r/) { logger "CR" }
        elsif ($c eq "j") { logger "down" }
        elsif ($c eq "k") { logger "up" }
        elsif ($c eq "h") { logger "left" }
        elsif ($c eq "l") { logger "right" }

        elsif ($c eq "J") { logger "DOWN" }
        elsif ($c eq "K") { logger "UP" }
        elsif ($c eq "H") { logger "LEFT" }
        elsif ($c eq "L") { logger "RIGHT" }

        elsif ($c eq "\e") { # handle a few escape sequences
            my $esc  = ReadKey 0;
               $esc .= ReadKey 0;
            if    ($esc eq "[A") { logger "up" }
            elsif ($esc eq "[B") { logger "down" }
            elsif ($esc eq "[C") { logger "right" }
            elsif ($esc eq "[D") { logger "left" }
            elsif ($esc eq "[5") { logger "page up" }
            elsif ($esc eq "[6") { logger "page down" }
            else { logger "Unrecognized escape: $esc"; }
        }

        else { logger "you typed: $c"; }
    }
}

ReadMode 0; # reset the terminal to normal mode
