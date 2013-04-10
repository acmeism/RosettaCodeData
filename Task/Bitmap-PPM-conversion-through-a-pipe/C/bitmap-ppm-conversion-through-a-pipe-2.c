#define MAXCMDBUF 100
void print_jpg(image img, int qual)
{
   char buf[MAXCMDBUF];
   unsigned int n;
   FILE *pipe;

   snprintf(buf, MAXCMDBUF, "convert ppm:- -quality %d jpg:-", qual);
   pipe = popen(buf, "w");
   if ( pipe != NULL )
   {
           fprintf(pipe, "P6\n%d %d\n255\n", img->width, img->height);
           n = img->width * img->height;
           fwrite(img->buf, sizeof(pixel), n, pipe);
           pclose(pipe);
   }
}
