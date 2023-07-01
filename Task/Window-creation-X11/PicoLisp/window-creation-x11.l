#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "@lib/misc.l" "@lib/gcc.l")

(gcc "x11" '("-lX11") 'simpleWin)

#include <X11/Xlib.h>

any simpleWin(any ex) {
   any x = cdr(ex);
   int dx, dy;
   Display *disp;
   int scrn;
   Window win;
   XEvent ev;

   x = cdr(ex),  dx = (int)evCnt(ex,x);
   x = cdr(x),  dy = (int)evCnt(ex,x);
   x = evSym(cdr(x));
   if (disp = XOpenDisplay(NULL)) {
      char msg[bufSize(x)];

      bufString(x, msg);
      scrn = DefaultScreen(disp);
      win = XCreateSimpleWindow(disp, RootWindow(disp,scrn), 0, 0, dx, dy,
                           1, BlackPixel(disp,scrn), WhitePixel(disp,scrn) );
      XSelectInput(disp, win, ExposureMask | KeyPressMask | ButtonPressMask);
      XMapWindow(disp, win);
      for (;;) {
         XNextEvent(disp, &ev);
         switch (ev.type) {
         case Expose:
            XDrawRectangle(disp, win, DefaultGC(disp, scrn), 10, 10, dx-20, dy-20);
            XDrawString(disp, win, DefaultGC(disp, scrn), 30, 40, msg, strlen(msg));
            break;
         case KeyPress:
         case ButtonPress:
            XCloseDisplay(disp);
            return Nil;
         }
      }
   }
   return mkStr("Can't open Display");
}
/**/

(simpleWin 300 200 "Hello World")
(bye)
