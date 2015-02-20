use NativeCall;

class Display is repr('CStruct') {}
class GC      is repr('CStruct') {}
class XEvent  is repr('CStruct') {
    has int32 $.type;  # for 32 bits machine
    #has int   $.type;  # for 64 bits machine
    method init { $!type = 0 }
}

sub XOpenDisplay(Str $name = ':0') returns Display is native('libX11') { * }
sub XDefaultScreen(Display $) returns int is native('libX11') { * }
sub XRootWindow(Display $, int $screen_number) returns int is native('libX11') { * }
sub XBlackPixel(Display $, int $screen_number) returns int is native('libX11') { * }
sub XWhitePixel(Display $, int $screen_number) returns int is native('libX11') { * }
sub XCreateSimpleWindow(
    Display $, int $parent_window, int $x, int $y,
    int $width, int $height, int $border_width,
    int $border, int $background
) returns int is native('libX11') { * }
sub XMapWindow(Display $, int $window) is native('libX11') { * }
sub XSelectInput(Display $, int $window, int $mask) is native('libX11') { * }
sub XFillRectangle(
    Display $, int $window, GC $, int $x, int $y, int $width, int $height
) is native('libX11') { * }
sub XDrawString(
    Display $, int $window, GC $, int $x, int $y, Str $, int $str_length
) is native('libX11') { * }
sub XDefaultGC(Display $, int $screen) returns GC is native('libX11') { * }
sub XNextEvent(Display $, XEvent $e)              is native('libX11') { * }
sub XCloseDisplay(Display $)                      is native('libX11') { * }

my Display $display = XOpenDisplay()
    or die "Can not open display";

my int $screen = XDefaultScreen($display);
my int $window = XCreateSimpleWindow(
    $display,
    XRootWindow($display, $screen),
    10, 10, 100, 100, 1,
    XBlackPixel($display, $screen), XWhitePixel($display, $screen)
);
XSelectInput($display, $window, 1 +< 15 +| 1);
XMapWindow($display, $window);

my Str $msg = 'Hello, World!';
my XEvent $e .= new; $e.init;
loop {
    XNextEvent($display, $e);
    if $e.type == 12 {
	XFillRectangle($display, $window, XDefaultGC($display, $screen), 20, 20, 10, 10);
	XDrawString($display, $window, XDefaultGC($display, $screen), 10, 50, $msg, my int $ = $msg.chars);
    }
    elsif $e.type == 2 {
	last;
    }
}
XCloseDisplay($display);
