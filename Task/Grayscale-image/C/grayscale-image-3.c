grayimage tograyscale(image img)
{
   unsigned int x, y;
   grayimage timg;
   double rc, gc, bc, l;
   unsigned int ofs;

   timg = alloc_grayimg(img->width, img->height);

   for(x=0; x < img->width; x++)
   {
      for(y=0; y < img->height; y++)
      {
        ofs = (y * img->width) + x;
        rc = (double) img->buf[ofs][0];
        gc = (double) img->buf[ofs][1];
        bc = (double) img->buf[ofs][2];
        l = 0.2126*rc + 0.7152*gc + 0.0722*bc;
        timg->buf[ofs][0] = (luminance) (l+0.5);
      }
   }
   return timg;
}
