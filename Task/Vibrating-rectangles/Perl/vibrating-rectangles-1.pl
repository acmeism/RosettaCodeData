use utf8;
binmode STDOUT, ":utf8";
use Time::HiRes qw(sleep);

%r = ('tl' => qw<┌>, 'tr' => qw<┐>, 'h' => qw<─>, 'v' => qw<│>, 'bl' => qw<└>, 'br' => qw<┘>);
@colors = ("\e[1;31m", "\e[1;32m", "\e[1;33m", "\e[1;34m", "\e[1;35m", "\e[1;36m");

print "\e[?25l"; # hide the cursor

$SIG{INT} = sub { print "\e[0H\e[0J\e[?25h"; exit; }; # clean up on exit

while (1) {
    @c = palette() unless $n % 16;
    rect($_, 31-$_) for 0..15;
    display(@vibe);
    sleep .20;
    push @c, $c[0]; shift @c;
    $n++;
}

sub palette {
    my @c = sort { -1 + 2*int(rand 2) } @colors;
    ($c[0], $c[1], $c[2]) x 12;
}

sub rect {
    my ($b, $e) = @_;
    my $c = $c[$b % @c];
    my @bb = ($c.$r{tl}, (($r{h})x($e-$b-1)), $r{tr}."\e[0m");
    my @ee = ($c.$r{bl}, (($r{h})x($e-$b-1)), $r{br}."\e[0m");
    $vibe[$b][$_] = shift @bb for $b .. $e;
    $vibe[$e][$_] = shift @ee for $b .. $e;
    $vibe[$_][$b] = $vibe[$_][$e] = $c.$r{v}."\e[0m" for $b+1 .. $e-1;
}

sub display {
    my(@rect) = @_;
    print "\e[0H\e[0J\n\n";
    for my $row (@rect) {
        print "\t\t\t";
        print $_ // ' ' for @$row;
        print "\n";
    }
}
