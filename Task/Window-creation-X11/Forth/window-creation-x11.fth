warnings off
require xlib.fs

0 value 	X11-D                 \ Display
0 value		X11-S                 \ Screen
0 value 	X11-root
0 value 	X11-GC
0 value 	X11-W                 \ Window
0 value 	X11-Black
0 value         X11-White
9 value 	X11-Top
0 value 	X11-Left
create 		X11-ev 96 allot

variable 	wm_delete

: X11-D-S 	X11-D X11-S ;
: X11-D-G       X11-D X11-GC ;
: X11-D-W 	X11-D X11-W ;
: X11-D-W-G     X11-D-W X11-GC ;

: open-X11 ( -- )
	X11-D 0= if 0 XOpendisplay to X11-D
		    X11-D    0= abort" can't connect to X server"
		    X11-D    XDefaultscreen to X11-S
		    X11-D-S  XRootwindow to X11-root
		    X11-D-S  XDefaultGC to X11-GC
		    X11-D-S  XBlackPixel to X11-Black
		    X11-D-S  XWhitePixel to X11-White
		then
	X11-W 0= if X11-D    X11-root X11-top X11-left 400 220  0 0 $808080 XCreateSimplewindow to X11-W
		    X11-W    0= abort" failed to create X11-window"
		    X11-D-W  $28043 XSelectInput drop
		    X11-D    s" WM_DELETE_WEINDOW" 1 XInternAtom wm_delete !
	            X11-D-W  wm_delete 1 XSetWMProtocols drop
		    X11-D-W  XMapwindow drop
		    X11-D    XFlush drop
		then ;

: close-graphics ( -- )
	X11-W if X11-D-W   XDestroywindow drop  0 to X11-W
	      then
        X11-D if X11-D     XClosedisplay  0 to X11-D
	      then ;

: foreground  	>r X11-D-G r> XSetForeground drop ;
: background  	>r X11-D-G r> XSetBackground drop ;
: keysym      	X11-ev     0 XLookupKeysym ;

: ev-loop
        begin X11-D X11-ev XNextEvent throw
	      X11-White    foreground
	      X11-Black    background
	      X11-D-W-G    100 100   s" Hello World" XDrawString drop
	      X11-D-W-G    100 120 150 25 XDrawRectangle drop
	      X11-D-W-G    110 135   s" Press ESC to exit ..." XDrawString drop
	      case X11-ev  @ $ffffffff and
	           3 of keysym XK_Escape = if exit then endof
	      endcase
	again ;
\ #### Test #####
0  open-X11
ev-loop
close-graphics
bye
