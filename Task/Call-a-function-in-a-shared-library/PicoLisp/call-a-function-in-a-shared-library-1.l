(load "@lib/gcc.l")

(gcc "x11" '("-lX11") 'xOpenDisplay 'xCloseDisplay)

#include <X11/Xlib.h>

any xOpenDisplay(any ex) {
   any x = evSym(cdr(ex));    // Get display name
   char display[bufSize(x)];  // Create a buffer for the name

   bufString(x, display);     // Upack the name
   return boxCnt((long)XOpenDisplay(display));
}

any xCloseDisplay(any ex) {
   return boxCnt(XCloseDisplay((Display*)evCnt(ex, cdr(ex))));
}
/**/

# With that we can open and close the display:
: (setq Display (xOpenDisplay ":0.7"))   # Wrong
-> 0
: (setq Display (xOpenDisplay ":0.0"))   # Correct
-> 158094320
: (xCloseDisplay Display)
-> 0
