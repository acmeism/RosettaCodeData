#!/bin/python
from PIL import Image, ImageFilter

if __name__=="__main__":
	im = Image.open("test.jpg")

	kernelValues = [-2,-1,0,-1,1,1,0,1,2] #emboss
	kernel = ImageFilter.Kernel((3,3), kernelValues)

	im2 = im.filter(kernel)

	im2.show()
