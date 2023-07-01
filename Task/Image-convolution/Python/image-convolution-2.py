#!/bin/python
import numpy as np
from scipy.ndimage.filters import convolve
from scipy.misc import imread, imshow

if __name__=="__main__":
	im = imread("test.jpg", mode="RGB")
	im = np.array(im, dtype=float) #Convert to float to prevent clipping colors

	kernel = np.array([[[0,-2,0],[0,-1,0],[0,0,0]],
						[[0,-1,0],[0,1,0],[0,1,0]],
						[[0,0,0],[0,1,0],[0,2,0]]])#emboss

	im2 = convolve(im, kernel)
	im3 = np.array(np.clip(im2, 0, 255), dtype=np.uint8) #Apply color clipping

	imshow(im3)
