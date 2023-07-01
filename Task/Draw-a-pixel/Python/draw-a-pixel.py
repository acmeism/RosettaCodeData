from PIL import Image

img = Image.new('RGB', (320, 240))
pixels = img.load()
pixels[100,100] = (255,0,0)
img.show()
