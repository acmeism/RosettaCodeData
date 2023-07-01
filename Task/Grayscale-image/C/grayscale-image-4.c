image tocolor(grayimage img)
{
   unsigned int x, y;
   image timg;
   luminance l;
   unsigned int ofs;

   timg = alloc_img(img->width, img->height);

   for(x=0; x < img->width; x++)
   {
      for(y=0; y < img->height; y++)
      {
        ofs = (y * img->width) + x;
        l = img->buf[ofs][0];
        timg->buf[ofs][0] = l;
        timg->buf[ofs][1] = l;
        timg->buf[ofs][2] = l;
      }
   }
   return timg;
}
