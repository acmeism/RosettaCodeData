myimg=: readppm jpath '~temp/myimg.ppm'
myimgGray=: toColor toGray myimg
myimgGray writeppm jpath '~temp/myimgGray.ppm'
