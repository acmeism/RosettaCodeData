use experimental :pack;

# Joysticks generally show up in the /dev/input/ directory as js(n) where n is
# the number assigned by the OS. E.G. /dev/input/js1 . In my particular case:

my $device = '/dev/input/js0';

my $exit = 0;

my $event-stream = $device.IO.open(:bin);
my $js = $event-stream.Supply(:8size);

my %config; # joystick configuration: number of axes and buttons
my %event;  # global "joystick event"

%config<button>.push: 0;

my $callback = sub { update };

sub get-js-event ( $ev, &callback ) {
    exit if $exit;
    # 32 bit timestamp milliseconds. Allows easy checking for "double-click" button presses
    %event<timestamp> = $ev.subbuf(0, 4).reverse.unpack('N');

    # 16 bit (signed int16) value of current control
    %event<value> = (my $v = $ev.subbuf(4, 2).unpack('S')) > 32767 ?? -65536 + $v !! $v;

    # Two 8 bit integers, current event: control type, and control ID
    (%event<type>, %event<number>) = $ev.subbuf(6).unpack('CC');

    # Process the event
    if %event<type> +& 128 {       # initialing
        given %event<type> +& 3  { # enumeration of control inputs
            when 1 { %config<button>.push: %event<number> }
            when 2 { %config<axis>.push: %event<number> }
        }
    } else {
        # Optional callback subroutine to run every time a js event is received
        callback
    }
}

# read events from the joystick driver asynchronously
start react whenever $js { $js.act: { get-js-event($_, $callback) } }

# allow a short delay while driver initializes
sleep .5;

# clean up on exit
signal(SIGINT).tap: {
    print "\e[0m", "\n" xx 50, "\e[H\e[J\e[?25hWaiting for one more joystick event...\n";
    $exit = 1;
    exit(0);
}

use Terminal::ANSIColor;

my ($rows, $cols) = qx/stty size/.words; # get the terminal size

my $xhair = '╺╋╸';
my $axis  = '█';
my @btext = %config<button>.map: { sprintf( "%2d", $_) };
my @button = @btext.map: {color('bold white on_blue ') ~ $_ ~ color('reset')};
my ($x, $y, $z) = ($rows/2).floor, ($cols/2).floor, 0;

sub update {
    given %event<type> {
        when 1 { # button event
            given %event<value> {
                when 0 { @button[%event<number>] = color('bold white on_blue ') ~ @btext[%event<number>] ~ color('reset') }
                when 1 { @button[%event<number>] = color('bold white on_green') ~ @btext[%event<number>] ~ color('reset') }
            }
        }
        when 2 { # axis events
            given %event<number> {
                when 0 { $y = ($cols / 2 + %event<value> / 32767 * $cols / 2).Int max 1 }
                when 1 { $x = ($rows / 2 + %event<value> / 32767 * $rows / 2).Int max 2 }
                when 2 { $z = (%event<value> / 32767 * 100).Int }
                default { } # only using the first 3 axes, ignore ant others
            }
            $x min= $rows - 1;
            $y min= $cols - 1;
        }
    }
    print "\e[H\e[J\e[1;1H";
    print "  ", join "  ", flat @button, "Axis 0: $x", "Axis 1: $y" , "Axis 2: $z%\n";
    my $bar = ($z / 100 * $cols / 2).floor;
    if $bar < 0 {
        print ' ' x ($bar + $cols / 2).floor, color('bold green') ~ $axis x -$bar ~ color('reset');
    } else {
        print ' ' x $cols / 2, color('bold green') ~ $axis x $bar ~ color('reset');
    }
    print "\e[{$x};{$y}H", color('bold yellow') ~ $xhair ~ color('reset');
}

print "\e[?25l"; # hide the cursor
update; # initial update

# Main loop, operates independently of the joystick event loop
loop {
    once say " Joystick has {%config<axis>.elems} axes and {%config<button>.elems} buttons";
    sleep 1;
    ($rows, $cols) = qx/stty size/.words;
}
