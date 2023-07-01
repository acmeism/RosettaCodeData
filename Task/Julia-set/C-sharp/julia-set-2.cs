        public struct CalculatedPoint
        {
            public int x;
            public int y;
            public int i;
        }

        static void MultiThreaded()
        {
            const int w = 800;
            const int h = 600;
            const int zoom = 1;
            const int maxiter = 255;
            const int moveX = 0;
            const int moveY = 0;
            const double cX = -0.7;
            const double cY = 0.27015;

            // Precalculate a pallette of 256 colors
            var colors = (from c in Enumerable.Range(0, 256)
                          select Color.FromArgb((c >> 5) * 36, (c >> 3 & 7) * 36, (c & 3) * 85)).ToArray();

            // The "AsParallel" below invokes PLINQ, making evaluation parallel using as many cores as
            // are available.
            var calculatedPoints = Enumerable.Range(0, w * h).AsParallel().Select(xy =>
              {
                  double zx, zy, tmp;
                  int x, y;
                  int i = maxiter;
                  y = xy / w;
                  x = xy % w;
                  zx = 1.5 * (x - w / 2) / (0.5 * zoom * w) + moveX;
                  zy = 1.0 * (y - h / 2) / (0.5 * zoom * h) + moveY;
                  while (zx * zx + zy * zy < 4 && i > 1)
                  {
                      tmp = zx * zx - zy * zy + cX;
                      zy = 2.0 * zx * zy + cY;
                      zx = tmp;
                      i -= 1;
                  }
                  return new CalculatedPoint { x = x, y = y, i = i };
              });

            // Bitmap is not multi-threaded, so main thread needs to read in the results as they
            // come in and plot the pixels.
            var bitmap = new Bitmap(w, h);
            foreach (CalculatedPoint cp in calculatedPoints)
                bitmap.SetPixel(cp.x, cp.y, colors[cp.i]);
            bitmap.Save("julia-set-multi.png");
        }
