sub cleanup { print "\e[0m\e[?25h\n"; exit(0) }

signal(SIGINT).tap: { cleanup(); exit(0) }

unit sub MAIN ($stack = 1000, :$hide-progress = False );

my @color = "\e[38;2;0;0;0m█",
            "\e[38;2;255;0;0m█",
            "\e[38;2;255;255;0m█",
            "\e[38;2;0;0;255m█",
            "\e[38;2;255;255;255m█"
            ;

my ($h, $w) = qx/stty size/.words».Int;
my $buf = $w * $h;
my @buffer = 0 xx $buf;
my $done;

@buffer[$w * ($h div 2) + ($w div 2) - 1] = $stack;

print "\e[?25l\e[48;5;232m";

repeat {
    $done = True;
    loop (my int $row; $row < $h; $row = $row + 1) {
        my int $rs = $row * $w; # row start
        my int $re = $rs  + $w; # row end
        loop (my int $idx = $rs; $idx < $re; $idx = $idx + 1) {
            if @buffer[$idx] >= 4 {
                my $grains = @buffer[$idx] div 4;
                @buffer[ $idx - $w ] += $grains if $row > 0;
                @buffer[ $idx - 1  ] += $grains if $idx - 1 >= $rs;
                @buffer[ $idx + $w ] += $grains if $row < $h - 1;
                @buffer[ $idx + 1  ] += $grains if $idx + 1 < $re;
                @buffer[ $idx ] %= 4;
                $done = False;
            }
        }
    }
    unless $hide-progress {
        print "\e[1;1H", @buffer.map( { @color[$_ min 4] }).join;
    }
} until $done;

print "\e[1;1H", @buffer.map( { @color[$_ min 4] }).join;

cleanup;
