use NativeCall;

sub XOpenDisplay(Str $s --> int64) is native('X11') {*}
sub XCloseDisplay(int64 $i --> int32) is native('X11') {*}

if try my $d = XOpenDisplay ":0.0" {
    say "ID = $d";
    XCloseDisplay($d);
}
else {
    say "No X11 library!";
    say "Use this window instead --> ⬜";
}
