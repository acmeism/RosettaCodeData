BEGIN
   FILE window;
   open (window, "Hello!", stand draw channel);
   draw device (window, "X", "600x400");
   draw erase (window);
   draw move (window, 0.25, 0.5);
   draw colour (window, 1, 0, 0);
   draw text (window, "c", "c", "Goodbye, world!");
   draw show (window);
   close (window)
END
