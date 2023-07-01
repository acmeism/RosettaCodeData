use NativeCall;

class Display is repr('CStruct') {
    has int32 $!screen;
    has int32 $!window;
 }
class GC      is repr('CStruct') {
    has int32 $!context;
}
class XEvent  is repr('CStruct') {
    has int32 $.type;
    method init { $!type = 0 }
}

sub XOpenDisplay(Str $name = ':0') returns Display is native('X11') { * }
sub XDefaultScreen(Display $) returns int32 is native('X11') { * }
sub XRootWindow(Display $, int32 $screen_number) returns int32 is native('X11') { * }
sub XBlackPixel(Display $, int32 $screen_number) returns int32 is native('X11') { * }
sub XWhitePixel(Display $, int32 $screen_number) returns int32 is native('X11') { * }
sub XCreateSimpleWindow(
    Display $, int32 $parent_window, int32 $x, int32 $y,
    int32 $width, int32 $height, int32 $border_width,
    int32 $border, int32 $background
) returns int32 is native('X11') { * }
sub XMapWindow(Display $, int32 $window) is native('X11') { * }
sub XSelectInput(Display $, int32 $window, int32 $mask) is native('X11') { * }
sub XFillRectangle(
    Display $, int32 $window, GC $, int32 $x, int32 $y, int32 $width, int32 $height
) is native('X11') { * }
sub XDrawString(
    Display $, int32 $window, GC $, int32 $x, int32 $y, Str $, int32 $str_length
) is native('X11') { * }
sub XDefaultGC(Display $, int32 $screen) returns GC is native('X11') { * }
sub XNextEvent(Display $, XEvent $e)              is native('X11') { * }
sub XCloseDisplay(Display $)                      is native('X11') { * }

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
