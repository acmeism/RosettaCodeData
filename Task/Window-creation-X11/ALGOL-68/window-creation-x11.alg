FILE window;
draw device (window, "X", "600x400");
open (window, "Hello, World!", stand draw channel);
  draw erase (window);
  draw move (window, 0.25, 0.5);
  draw colour (window, 1, 0, 0);
  draw text (window, "c", "c", "hello world");
  draw show (window);
  VOID (read char);
close (window)
