from PIL import Image

if __name__=="__main__":
	im = Image.open("frog.png")
	im2 = im.quantize(16)
	im2.show()
