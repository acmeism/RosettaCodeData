def get_pixel_colour(i_x, i_y):
	import PIL.ImageGrab
	return PIL.ImageGrab.grab().load()[i_x, i_y]

print get_pixel_colour(0, 0)
