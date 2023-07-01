#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <xcb/xcb.h>

int main ()
{
  xcb_connection_t    *c;
  xcb_screen_t        *screen;
  xcb_drawable_t       win;
  xcb_gcontext_t       foreground;
  xcb_gcontext_t       background;
  xcb_generic_event_t *e;
  uint32_t             mask = 0;
  uint32_t             values[2];

  char string[] = "Hello, XCB!";
  uint8_t string_len = strlen(string);

  xcb_rectangle_t rectangles[] = {
    {40, 40, 20, 20},
  };

  c = xcb_connect (NULL, NULL);

  /* get the first screen */
  screen = xcb_setup_roots_iterator (xcb_get_setup (c)).data;

  /* root window */
  win = screen->root;

  /* create black (foreground) graphic context */
  foreground = xcb_generate_id (c);
  mask = XCB_GC_FOREGROUND | XCB_GC_GRAPHICS_EXPOSURES;
  values[0] = screen->black_pixel;
  values[1] = 0;
  xcb_create_gc (c, foreground, win, mask, values);

  /* create white (background) graphic context */
  background = xcb_generate_id (c);
  mask = XCB_GC_BACKGROUND | XCB_GC_GRAPHICS_EXPOSURES;
  values[0] = screen->white_pixel;
  values[1] = 0;
  xcb_create_gc (c, background, win, mask, values);

  /* create the window */
  win = xcb_generate_id(c);
  mask = XCB_CW_BACK_PIXEL | XCB_CW_EVENT_MASK;
  values[0] = screen->white_pixel;
  values[1] = XCB_EVENT_MASK_EXPOSURE | XCB_EVENT_MASK_KEY_PRESS;
  xcb_create_window (c,                             /* connection    */
                     XCB_COPY_FROM_PARENT,          /* depth         */
                     win,                           /* window Id     */
                     screen->root,                  /* parent window */
                     0, 0,                          /* x, y          */
                     150, 150,                      /* width, height */
                     10,                            /* border_width  */
                     XCB_WINDOW_CLASS_INPUT_OUTPUT, /* class         */
                     screen->root_visual,           /* visual        */
                     mask, values);                 /* masks         */

  /* map the window on the screen */
  xcb_map_window (c, win);

  xcb_flush (c);

  while ((e = xcb_wait_for_event (c))) {
    switch (e->response_type & ~0x80) {
    case XCB_EXPOSE:
      xcb_poly_rectangle (c, win, foreground, 1, rectangles);
      xcb_image_text_8 (c, string_len, win, background, 20, 20, string);
      xcb_flush (c);
      break;
    case XCB_KEY_PRESS:
      goto endloop;
    }
    free (e);
  }
  endloop:

  return 0;
}
