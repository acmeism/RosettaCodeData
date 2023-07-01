def get_pixel_colour(i_x, i_y):
	import PyQt4.QtGui # python-qt4
	app = PyQt4.QtGui.QApplication([])
	long_qdesktop_id = PyQt4.QtGui.QApplication.desktop().winId()
	long_colour = PyQt4.QtGui.QPixmap.grabWindow(long_qdesktop_id, i_x, i_y, 1, 1).toImage().pixel(0, 0)
	i_colour = int(long_colour)
	return ((i_colour >> 16) & 0xff), ((i_colour >> 8) & 0xff), (i_colour & 0xff)

print (get_pixel_colour(0, 0))
