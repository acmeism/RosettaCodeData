#include <stdio.h>
#include <string.h>
#include <magick/MagickCore.h>

int CannyEdgeDetector(
   const char *infile, const char *outfile,
   double radius, double sigma, double lower, double upper ) {

   ExceptionInfo   *exception;
   Image           *image, *processed_image, *output;
   ImageInfo       *input_info;

   exception   = AcquireExceptionInfo();
   input_info  = CloneImageInfo((ImageInfo *) NULL);
   (void) strcpy(input_info->filename, infile);
   image       = ReadImage(input_info, exception);
   output      = NewImageList();
   processed_image = CannyEdgeImage(image,radius,sigma,lower,upper,exception);
   (void) AppendImageToList(&output, processed_image);
   (void) strcpy(output->filename, outfile);
   WriteImage(input_info, output);
                                    // after-party clean up
   DestroyImage(image);
   output=DestroyImageList(output);
   input_info=DestroyImageInfo(input_info);
   exception=DestroyExceptionInfo(exception);
   MagickCoreTerminus();

   return 0;
}
