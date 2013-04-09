def get_pixel_colour(i_x, i_y):
	import gtk # python-gtk2
	o_gdk_pixbuf = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, False, 8, 1, 1)
	o_gdk_pixbuf.get_from_drawable(gtk.gdk.get_default_root_window(), gtk.gdk.colormap_get_system(), i_x, i_y, 0, 0, 1, 1)
	return tuple(o_gdk_pixbuf.get_pixels_array().tolist()[0][0])

print get_pixel_colour(0, 0)
