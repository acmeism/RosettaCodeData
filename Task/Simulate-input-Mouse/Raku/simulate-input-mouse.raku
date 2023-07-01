use X11::libxdo;
my $xdo = Xdo.new;

my ($dw, $dh) = $xdo.get-desktop-dimensions( 0 );

sleep .25;

for ^$dw -> $mx {
    my $my = (($mx / $dh * τ).sin * 500).abs.Int + 200;
    $xdo.move-mouse( $mx, $my, 0 );
    my ($x, $y, $window-id, $screen) = $xdo.get-mouse-info;
    my $name = (try $xdo.get-window-name($window-id) if $window-id)
       // 'No name set';

    my $line = "Mouse location: x=$x : y=$y\nWindow under mouse:\nWindow ID: " ~
       $window-id ~ "\nWindow name: " ~ $name ~ "\nScreen #: $screen";

    print "\e[H\e[J", $line;
    sleep .001;
}

say '';

#`[ There are several available routines controlling mouse position and button events.

.move-mouse( $x, $y, $screen ) # Move the mouse to a specific location.

.move-mouse-relative( $delta-x, $delta-y ) # Move the mouse relative to it's current position.

.move-mouse-relative-to-window( $x, $y, $window ) # Move the mouse to a specific location relative to the top-left corner of a window.

.get-mouse-location() # Get the current mouse location (coordinates and screen ID number).

.get-mouse-info() # Get all mouse location-related data.

.wait-for-mouse-to-move-from( $origin-x, $origin-y ) # Wait for the mouse to move from a location.

.wait-for-mouse-to-move-to( $dest-x, $dest-y ) # Wait for the mouse to move to a location.

.mouse-button-down( $window, $button ) # Send a mouse press (aka mouse down) for a given button at the current mouse location.

.mouse-button-up( $window, $button ) # Send a mouse release (aka mouse up) for a given button at the current mouse location.

.mouse-button-click( $window, $button ) # Send a click for a specific mouse button at the current mouse location.

.mouse-button-multiple( $window, $button, $repeat = 2, $delay? ) # Send a one or more clicks of a specific mouse button at the current mouse location.
]
