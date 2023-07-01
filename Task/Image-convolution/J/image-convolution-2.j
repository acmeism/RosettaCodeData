NB. kernels borrowed from C and TCL implementations
id_kernel=: (=&i.-)3 3
sharpen_kernel=: ({ _1,#@,)id_kernel
blur_kernel=: ($ *&%/)3 3
emboss_kernel=: id_kernel+(+/~ - >./)i.3
sobel_emboss_kernel=: (i:-:<:3)*/1+(<.|.)i.3

   'blurred.ppm' writeppm~ blur_kernel kernel_filter readppm 'original.ppm'
