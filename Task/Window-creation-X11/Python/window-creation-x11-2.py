import xcb
from xcb.xproto import *
import xcb.render

def main():
  conn = xcb.connect()
  conn.render = conn(xcb.render.key)

  setup = conn.get_setup()
  root = setup.roots[0].root
  depth = setup.roots[0].root_depth
  visual = setup.roots[0].root_visual
  white = setup.roots[0].white_pixel

  window = conn.generate_id()
  conn.core.CreateWindow(depth, window, root,
                         0, 0, 640, 480, 0,
                         WindowClass.InputOutput,
                         visual,
                         CW.BackPixel | CW.EventMask,
                         [ white, EventMask.Exposure |
                                  EventMask.KeyPress ])

  conn.core.MapWindow(window)
  conn.flush()

  while True:
    event = conn.wait_for_event()

    if isinstance(event, ExposeEvent):
      color = (0, 0, 65535, 65535)
      rectangle = (20, 20, 40, 40)
      # TODO, fixme:
      # I haven't been able to find what I should put for the parameter "op"
   #  conn.render.FillRectangles(op, window, color, 1, rectangle)
      conn.flush()

    elif isinstance(event, KeyPressEvent):
      break

  conn.disconnect()

main()
