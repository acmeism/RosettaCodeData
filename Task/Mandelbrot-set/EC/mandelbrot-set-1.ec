void drawMandelbrot(Bitmap bmp, float range, Complex center, ColorAlpha * palette, int nPalEntries, int nIterations, float scale)
{
   int x, y;
   int w = bmp.width, h = bmp.height;
   ColorAlpha * picture = (ColorAlpha *)bmp.picture;
   double logOf2 = log(2);
   Complex d
   {
      w > h ? range : range * w / h,
      h > w ? range : range * h / w
   };
   Complex C0 { center.a - d.a/2, center.b - d.b/2 };
   Complex C = C0;
   double delta = d.a / w;

   for(y = 0; y < h; y++, C.a = C0.a, C.b += delta)
   {
      for(x = 0; x < w; x++, picture++, C.a += delta)
      {
         Complex Z { };
         int i;
         double ii = 0;
         bool out = false;
         double Za2 = Z.a * Z.a, Zb2 = Z.b * Z.b;
         for(i = 0; i < nIterations; i++)
         {
            double z2;
            Z = { Za2 - Zb2, 2*Z.a*Z.b };
            Z.a += C.a;
            Z.b += C.b;
            Za2 = Z.a * Z.a, Zb2 = Z.b * Z.b;
            z2 = Za2 + Zb2;

            if(z2 >= 2*2)
            {
               ii = (double)(i + 1 - log(0.5 * log(z2)) / logOf2);
               out = true;
               break;
            }
         }
         if(out)
         {
            float si = (float)(ii * scale);
            int i0 = ((int)si) % nPalEntries;
            *picture = palette[i0];
         }
         else
            *picture = black;
      }
   }
}
