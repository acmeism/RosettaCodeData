import math
import colorsys
from PIL import Image

def plasma (w, h):
	out = Image.new("RGB", (w, h))
	pix = out.load()
	for x in range (w):
		for y in range(h):
			hue = 4.0 + math.sin(x / 19.0) + math.sin(y / 9.0) \
				+ math.sin((x + y) / 25.0) + math.sin(math.sqrt(x**2.0 + y**2.0) / 8.0)
			hsv = colorsys.hsv_to_rgb(hue/8.0, 1, 1)
			pix[x, y] = tuple([int(round(c * 255.0)) for c in hsv])
	return out

if __name__=="__main__":
	im = plasma(400, 400)
	im.show()
