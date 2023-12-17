// dotrosetta.c - https://rosettacode.org/wiki/Draw_a_pixel

#include <X11/Xutil.h>
#include <stdio.h>
#include <stdlib.h>

int
main(void)
	{
	Atom wm_both_protocols[1];
	Atom wm_delete;
	Atom wm_protocols;
	Display *display;
	GC gc;
	Window root;
	Window window;
	XEvent event;
	XSetWindowAttributes attr;
	int more = 1;

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
	attr.event_mask = ExposureMask;
	window = XCreateWindow(display, root,
		0, 0, 320, 240, 0,
		CopyFromParent, InputOutput, CopyFromParent,
		CWBackPixel | CWEventMask,
		&attr
		);
	XStoreName(display, window, "Draw a Pixel");
	wm_both_protocols[0] = wm_delete;
	XSetWMProtocols(display, window, wm_both_protocols, 1);
	gc = XCreateGC(display, window, 0, NULL);
	XSetForeground(display, gc, 0xFF0000);
	XMapWindow(display, window);

	while(more)
		{
		XNextEvent(display, &event);
		switch(event.type)
			{
		case Expose:
			XDrawPoint(display, window, gc, 100, 100);
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

		default:
			printf("unexpected event.type %d\n", event.type);;
			}
		}

	XCloseDisplay(display);
	exit(0);
	}
