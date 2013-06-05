my $TTY = open("/dev/tty");
my @INPUT;

sub log($mess) { print "$mess\r\n" }

INIT { shell "stty raw -echo min 1 time 1"; log "(raw mode)"; }
END { shell "stty sane"; log "(sane mode)"; }

loop {
    push @INPUT, $TTY.getc unless @INPUT;
    given @INPUT.shift {
        when "q" | "\c4" { log "QUIT"; last; }

        when "\r" { log "CR" }

        when "j" { log "down" }
        when "k" { log "up" }
        when "h" { log "left" }
        when "l" { log "right" }

        when "J" { log "DOWN" }
        when "K" { log "UP" }
        when "H" { log "LEFT" }
        when "L" { log "RIGHT" }

        when "\e" {
            my $esc = '';
            repeat until my $x ~~ /^<alpha>$/ {
                push @INPUT, $TTY.getc unless @INPUT;
                $x = @INPUT.shift;
                $esc ~= $x;
            }
            given $esc {
                when "[A" { log "up" }
                when "[B" { log "down" }
                when "[C" { log "right" }
                when "[D" { log "left" }
                when "[1;2A" { log "UP" }
                when "[1;2B" { log "DOWN" }
                when "[1;2C" { log "RIGHT" }
                when "[1;2D" { log "LEFT" }
                default { log "Unrecognized escape: $esc"; }
            }
        }
        default { log "Unrecognized key: $_"; }
    }
}
