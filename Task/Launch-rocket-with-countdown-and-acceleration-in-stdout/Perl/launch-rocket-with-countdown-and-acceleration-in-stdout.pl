use strict;
use warnings;
use Time::HiRes qw(sleep);

$SIG{INT} = \&clean_up;

my ($rows,$cols) = split /\s+/, qx/stty size/;
my $v =  $rows - 9;
my $h =  int $cols / 2 - 4;
my $a =  0;
my $i =  0;
my $j =  0;
my $t = -5;
my $start = $^T;

my @r = (q'   |',    q'  /_\\',   q'  | |',   q' /| |\\', q'/_|_|_\\');
my @x = (q' (/|\\)', q' {/|\\}',  q'  \\|/',  q'   |');
my @y = (q'  /|\\',  q' // \\\\', q' (/ \\)', q'  \\ /');

my $sp = ' ' x $h;

my $altitude = 0;
my $velocity = 0;

my @pal = ("\e[38;2;255;0;0m", "\e[38;2;255;255;0m", "\e[38;2;255;155;0m");
use constant W => "\e[38;2;255;255;255m";

print "\e[?25l\e[48;5;232m";

while (1) {
    if ($t >= 0) {
        $velocity = 5 * $t**2;
        $altitude = $velocity * $t / 2;
        $a = int 0.5 + ($altitude / $v);
    }
    clean_up() if $a > $rows + 5;

    print "\e[H\e[J", ("\n")x$v, W, $sp, join("\n$sp",@r), "\n", $sp;

    if ($t < 0) {
        print q'\\/   \\/'
    } else {
        exhaust( $pal[$i], $a )
    }
    print W, "\n", '▔' x $cols, $pal[1];
    printf "\n Time: T %-4s %9s  Altitude: %6.2f meters  Velocity: %5.1f m/sec\n",
    $t < 0 ? '- ' . int 0.5 + abs $t : '+ ' . int 0.5 + $t,
    $t < 0 ? '' : $a == 0 ? 'Ignition!' : 'Lift-off!',
    sprintf('%.2f', $altitude), sprintf('%.1f', $velocity);

    ++$i;
    $i %= 3;
    ++$j;
    $j %= 2;
    $t = (time() - $start - 5);
    sleep .05;
}

sub exhaust {
    my($clr, $a) = @_;
    print q'\\/', $clr, q'/^\\', W, q'\\/';
    return if $a == 0;
    if ($a < 4) {
        print "\n", $clr,
        $sp, ( $j ? join("\n$sp", @x[0..$a-1]) : join("\n$sp", @y[0..$a-1]) )
    } else {
        print "\n", $clr,
        $sp, ( $j ? join("\n$sp",@x) : join("\n$sp",@y) );
        print "\n" x ($a-4);
    }
}

# clean up on exit, reset ANSI codes, scroll, re-show the cursor & clear screen
sub clean_up { print "\e[0m", ("\n")x50, "\e[H\e[J\e[?25h"; exit(0) }
