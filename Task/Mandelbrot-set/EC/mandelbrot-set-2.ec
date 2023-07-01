class Mandelbrot : Window
{
   caption = $"Mandelbrot";
   borderStyle = sizable;
   hasMaximize = true;
   hasMinimize = true;
   hasClose = true;
   clientSize = { 600, 600 };

   Point mouseStart, mouseEnd;
   bool dragging;
   bool needUpdate;

   float scale;
   int nIterations; nIterations = 256;
   ColorAlpha * palette;
   int nPalEntries;
   Complex center { -0.75, 0 };

   float range; range = 4;
   Bitmap bmp { };

   Mandelbrot()
   {
      static ColorKey keys[] =
      {
         { navy, 0.0f },
         { Color { 146, 213, 237 }, 0.198606268f },
         { white, 0.3f },
         { Color { 255, 255, 124 }, 0.444250882f },
         { Color { 255, 100, 0 }, 0.634146333f },
         { navy, 1 }
      };

      nPalEntries = 30000;
      palette = new ColorAlpha[nPalEntries];
      scale = nPalEntries / 175.0f;
      PaletteGradient(palette, nPalEntries, keys, sizeof(keys)/sizeof(keys[0]), 1.0);
      needUpdate = true;
   }

   ~Mandelbrot() { delete palette; }

   void OnRedraw(Surface surface)
   {
      if(needUpdate)
      {
         drawMandelbrot(bmp, range, center, palette, nPalEntries, nIterations, scale);
         needUpdate = false;
      }
      surface.Blit(bmp, 0,0, 0,0, bmp.width, bmp.height);

      if(dragging)
      {
         surface.foreground = lime;
         surface.Rectangle(mouseStart.x, mouseStart.y, mouseEnd.x, mouseEnd.y);
      }
   }

   bool OnLeftButtonDown(int x, int y, Modifiers mods)
   {
      mouseEnd = mouseStart = { x, y };
      Capture();
      dragging = true;
      Update(null);
      return true;
   }

   bool OnLeftButtonUp(int x, int y, Modifiers mods)
   {
      if(dragging)
      {
         int dx = Abs(mouseEnd.x - mouseStart.x), dy = Abs(mouseEnd.y - mouseStart.y);
         if(dx > 4 && dy > 4)
         {
            int w = clientSize.w, h = clientSize.h;
            float rangeX = w > h ? range : range * w / h;
            float rangeY = h > w ? range : range * h / w;

            center.a += ((mouseStart.x + mouseEnd.x) - w) / 2.0f * rangeX / w;
            center.b += ((mouseStart.y + mouseEnd.y) - h) / 2.0f * rangeY / h;

            range = dy > dx ? dy * range / h : dx * range / w;

            needUpdate = true;
            Update(null);
         }
         ReleaseCapture();
         dragging = false;
      }
      return true;
   }

   bool OnMouseMove(int x, int y, Modifiers mods)
   {
      if(dragging)
      {
         mouseEnd = { x, y };
         Update(null);
      }
      return true;
   }

   bool OnRightButtonDown(int x, int y, Modifiers mods)
   {
      range = 4;
      nIterations = 256;
      center = { -0.75, 0 };
      needUpdate = true;
      Update(null);
      return true;
   }

   void OnResize(int width, int height)
   {
      bmp.Allocate(null, width, height, 0, pixelFormat888, false);
      needUpdate = true;
      Update(null);
   }

   bool OnKeyHit(Key key, unichar ch)
   {
      switch(key)
      {
         case space: case keyPadPlus: case plus:
            nIterations += 256;
            needUpdate = true;
            Update(null);
            break;
      }
      return true;
   }
}

Mandelbrot mandelbrotForm {};
