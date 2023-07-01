val img=new RgbBitmap(50, 50);
img.fill(Color.CYAN)
img.setPixel(5, 5, Color.BLUE)

assert(img.getPixel(1,1)==Color.CYAN)
assert(img.getPixel(5,5)==Color.BLUE)
assert(img.width==50)
assert(img.height==50)
