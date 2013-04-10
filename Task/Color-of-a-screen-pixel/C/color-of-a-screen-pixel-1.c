#include <X11/Xlib.h>
void
get_pixel_color (Display *d, int x, int y, XColor *color)
{
  XImage *image;
  image = XGetImage (d, RootWindow (d, DefaultScreen (d)), x, y, 1, 1, AllPlanes, XYPixmap);
  color->pixel = XGetPixel (image, 0, 0);
  XFree (image);
  XQueryColor (d, DefaultColormap(d, DefaultScreen (d)), color);
}

// Your code
XColor c;
get_pixel_color (display, 30, 40, &c);
printf ("%d %d %d\n", c.red, c.green, c.blue);
