histogram get_histogram(grayimage im)
{
   histogram t;
   unsigned int x, y;

   if ( im == NULL ) return NULL;
   t = malloc( sizeof(histogram_t)*256 );
   memset(t, 0, sizeof(histogram_t)*256 );
   if (t!=NULL)
   {
       for(x=0; x < im->width; x++ )
       {
         for(y=0; y < im->height; y++ )
         {
            t[ GET_LUM(im, x, y) ]++;
         }
       }
   }
   return t;
}
