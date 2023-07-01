grayimage alloc_grayimg(unsigned int width, unsigned int height)
{
     grayimage img;
     img = malloc(sizeof(grayimage_t));
     img->buf = malloc(width*height*sizeof(pixel1));
     img->width = width;
     img->height = height;
     return img;
}
