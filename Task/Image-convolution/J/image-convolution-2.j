   NB. kernels borrowed from C and TCL implementations
   sharpen_kernel=: _1+10*4=i.3 3
   blur_kernel=: 3 3$%9
   emboss_kernel=: _2 _1 0,_1 1 1,:0 1 2
   sobel_emboss_kernel=: _1 _2 _1,0,:1 2 1

   'blurred.ppm' writeppm~ blur_kernel kernel_filter readppm 'original.ppm'
