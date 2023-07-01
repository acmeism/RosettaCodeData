use X11::libxdo;

my $xdo = Xdo.new;

my $active = $xdo.get-active-window;

my $command = $*VM.config<os> eq 'darwin' ?? 'open' !! 'xdg-open';

shell "$command https://www.google.com";

sleep 1;

my $match = rx[^'Google '];

say my $w = $xdo.search(:name($match))<ID>;

sleep .25;

if $w {
    $xdo.activate-window($w);
    say "Window name: ", $xdo.get-window-name( $w );
    $xdo.type($w, 'Raku language');
    sleep .25;
    $xdo.send-sequence($w, 'Tab');
    sleep .5;
    $xdo.send-sequence($w, 'Tab');
    sleep .5;
    $xdo.send-sequence($w, 'Tab');
    sleep .5;
    $xdo.send-sequence($w, 'Return');
}
