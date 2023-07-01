// clockrosetta.c - https://rosettacode.org/wiki/Draw_a_clock

// # Makefile
// CFLAGS = -O3 -Wall -Wfatal-errors -Wpedantic -Werror
// LDLIBS = -lX11 -lXext -lm
// all:  clockrosetta

#define SIZE 500

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/select.h>
#include <time.h>
#include <X11/extensions/Xdbe.h>
#include <math.h>

static XdbeBackBuffer dbewindow = 0;
static Display *display;
static Window window;
static int needseg = 1;
static double d2r;
static XSegment seg[61];
static GC gc;
static int mw = SIZE / 2;
static int mh = SIZE / 2;

static void
draw(void)
  {
  struct tm *ptm;
  int i;
  double angle;
  double delta;
  int radius = (mw < mh ? mw : mh) - 2;
  XPoint pt[3];
  double onetwenty = 3.1415926 * 2 / 3;
  XdbeSwapInfo swapi;
   time_t newtime;

  if(dbewindow == 0)
    {
    dbewindow = XdbeAllocateBackBufferName(display, window, XdbeBackground);
    XClearWindow(display, window);
    }

  time(&newtime);
  ptm = localtime(&newtime);

  if(needseg)
    {
    d2r = atan2(1.0, 0.0) / 90.0;
    for(i = 0; i < 60; i++)
      {
      angle = (double)i * 6.0 * d2r;
      delta = i % 5 ? 0.97 : 0.9;
      seg[i].x1 = mw + radius * delta * sin(angle);
      seg[i].y1 = mh - radius * delta * cos(angle);
      seg[i].x2 = mw + radius * sin(angle);
      seg[i].y2 = mh - radius * cos(angle);
      }
    needseg = 0;
    }

  angle = (double)(ptm->tm_sec) * 6.0 * d2r;
  seg[60].x1 = mw;
  seg[60].y1 = mh;
  seg[60].x2 = mw + radius * 0.9 * sin(angle);
  seg[60].y2 = mh - radius * 0.9 * cos(angle);
  XDrawSegments(display, dbewindow, gc, seg, 61);

  angle = (double)ptm->tm_min * 6.0 * d2r;
  pt[0].x = mw + radius * 3 / 4 * sin(angle);
  pt[0].y = mh - radius * 3 / 4 * cos(angle);
  pt[1].x = mw + 6 * sin(angle + onetwenty);
  pt[1].y = mh - 6 * cos(angle + onetwenty);
  pt[2].x = mw + 6 * sin(angle - onetwenty);
  pt[2].y = mh - 6 * cos(angle - onetwenty);
  XFillPolygon(display, dbewindow, gc, pt, 3, Nonconvex, CoordModeOrigin);

  angle = (double)(ptm->tm_hour * 60 + ptm->tm_min) / 2.0 * d2r;
  pt[0].x = mw + radius / 2 * sin(angle);
  pt[0].y = mh - radius / 2 * cos(angle);
  pt[1].x = mw + 6 * sin(angle + onetwenty);
  pt[1].y = mh - 6 * cos(angle + onetwenty);
  pt[2].x = mw + 6 * sin(angle - onetwenty);
  pt[2].y = mh - 6 * cos(angle - onetwenty);
  XFillPolygon(display, dbewindow, gc, pt, 3, Nonconvex, CoordModeOrigin);

  swapi.swap_window = window;
  swapi.swap_action = XdbeBackground;
  XdbeSwapBuffers(display, &swapi, 1);
  }

int
main(int argc, char *argv[])
  {
  Atom wm_both_protocols[1];
  Atom wm_delete;
  Atom wm_protocols;
  Window root;
  XEvent event;
  XSetWindowAttributes attr;
  fd_set fd;
  int exposed = 0;
  int more = 1;
  struct timeval tv;

  display = XOpenDisplay(NULL);

  if(display == NULL)
    {
    fprintf(stderr,"Error: The display cannot be opened\n");
    exit(1);
    }

  root = DefaultRootWindow(display);
  wm_delete = XInternAtom(display, "WM_DELETE_WINDOW", False);
  wm_protocols = XInternAtom(display, "WM_PROTOCOLS", False);

  attr.background_pixel = 0x000000;
  attr.event_mask = KeyPress | KeyRelease |
    ButtonPressMask | ButtonReleaseMask | ExposureMask;

  window = XCreateWindow(display, root,
    0, 0, SIZE, SIZE, 0,
    CopyFromParent, InputOutput, CopyFromParent,
    CWBackPixel | CWEventMask,
    &attr
    );

  XStoreName(display, window, "Clock for RosettaCode");

  wm_both_protocols[0] = wm_delete;
  XSetWMProtocols(display, window, wm_both_protocols, 1);

  gc = XCreateGC(display, window, 0, NULL);
  XSetForeground(display, gc, 0xFFFF80);

  XMapWindow(display, window);

  while(more)
    {
    if(QLength(display) > 0)
      {
      XNextEvent(display, &event);
      }
    else
      {
      int maxfd = ConnectionNumber(display);

      XFlush(display);
      FD_ZERO(&fd);
      FD_SET(ConnectionNumber(display), &fd);

      event.type = LASTEvent;
      tv.tv_sec = 0;
      tv.tv_usec = 250000;
      if(select(maxfd + 1, &fd, NULL, NULL, &tv) > 0)
        {
        if(FD_ISSET(ConnectionNumber(display), &fd))
          {
          XNextEvent(display, &event);
          }
        }
      }

    switch(event.type)
      {
    case Expose:
      exposed = 1;
      draw();
      break;

    case ButtonRelease:
    case KeyRelease:
      more = 0;
    case ButtonPress:  // ignore
    case KeyPress:     // ignore
      break;

    case LASTEvent:  // the timeout comes here
      if(exposed) draw();
      break;

    case ConfigureNotify:
      mw = event.xconfigure.width / 2;
      mh = event.xconfigure.height / 2;
      needseg = 1;
      break;


    case ClientMessage: // for close request from WM
      if(event.xclient.window == window &&
        event.xclient.message_type == wm_protocols &&
        event.xclient.format == 32 &&
        event.xclient.data.l[0] == wm_delete)
        {
        more = 0;
        }
      break;

//    default:
//      printf("unexpected event.type %d\n", event.type);;
      }
    }

  XCloseDisplay(display);
  exit(0);
  }

// END
