use X11::libxdo;

my $xdo = Xdo.new;

say 'Visible windows:';
printf "Class: %-21s ID#: %10d  pid: %5d  Name: %s\n", $_<class ID pid name>
    for $xdo.get-windows.sort(+*.key)».value;
sleep 2;

my $id = $xdo.get-active-window;

my ($w,  $h ) = $xdo.get-window-size( $id );
my ($wx, $wy) = $xdo.get-window-location( $id );
my ($dw, $dh) = $xdo.get-desktop-dimensions( 0 );

$xdo.move-window( $id, 150, 150 );

$xdo.set-window-size( $id, 350, 350, 0 );

sleep .25;

for flat 1 .. $dw - 350, $dw - 350, {$_ - 1} … 1 -> $mx { #
    my $my = (($mx / $dw * τ).sin * 500).abs.Int;
    $xdo.move-window( $id, $mx, $my );
    $xdo.activate-window($id);
}

sleep .25;

$xdo.move-window( $id, 150, 150 );

my $dx = $dw - 300;
my $dy = $dh - 300;

$xdo.set-window-size( $id, $dx, $dy, 0 );

sleep .25;

my $s = -1;

loop {
    $dx += $s * ($dw / 200).ceiling;
    $dy += $s * ($dh / 200).ceiling;
    $xdo.set-window-size( $id, $dx, $dy, 0 );
    $xdo.activate-window($id);
    sleep .005;
    $s *= -1 if $dy < 200;
    last if $dx >= $dw;
}

sleep .25;

$xdo.set-window-size( $id, $w, $h, 0 );
$xdo.move-window( $id, $wx, $wy );
$xdo.activate-window($id);

sleep .25;

$xdo.minimize($id);
$xdo.activate-window($id);
sleep 1;
$xdo.raise-window($id);
sleep .25;
