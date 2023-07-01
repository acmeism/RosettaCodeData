[PRAGMA] usestackflood                 \ don't use additional memory for fill
include lib/graphics.4th               \ load the graphics library
include lib/gcircle.4th                \ we need a full circle
include lib/garccirc.4th               \ we need a partial circle
include lib/gflood.4th                 \ we need a flood fill

600 pic_width ! 600 pic_height !       \ set canvas size
color_image 255 whiteout black         \ paint black on white

300 300 296 circle                     \ make the large circle
152 300  49 circle                     \ make the top small circle
448 300  49 circle                     \ make the bottom small circle

152 300 149 -15708 31416 arccircle     \ create top teardrop
448 300 148  15708 31416 arccircle     \ create bottom teardrop

150 300 flood                          \ fill the top small circle
500 300 flood                          \ fill the bottom teardrop

300 300 295 circle                     \ let's make it a double line width

s" gyinyang.ppm" save_image            \ save the image
