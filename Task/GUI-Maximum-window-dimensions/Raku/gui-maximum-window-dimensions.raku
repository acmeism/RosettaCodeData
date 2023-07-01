use X11::libxdo;

my $xdo = Xdo.new;

my ($dw, $dh) = $xdo.get-desktop-dimensions( 0 );

say "Desktop viewport dimensions: (maximum-fullscreen size) $dw x $dh";
